local Option = require("../luau_packages/option")
type Option<T> = Option.Option<T>

local Result = require("../luau_packages/result")
type Result<T, E> = Result.Result<T, E>

local function stringStartsWith(str: string, sub: string)
	return string.sub(str, 1, #sub) == sub
end

local function hasLeadingZeros(num: string)
	return string.match(num, "^(0+)") ~= nil
end

local function doLeadingZeroesCheck(type: "major" | "minor" | "patch", component: string)
	-- We only do this check if each component has more than 1 digit as an optimization
	if #component > 1 and hasLeadingZeros(component) then
		return Result.Err({
			msg = Option.Some(`Found disallowed leading zeros in {string.upper(type)} component`),
			kind = {
				id = "LeadingZerosPresent",
				component = type,
			} :: ParseError,
		} :: SemverError)
	end

	return Result.Ok(nil)
end

type InvalidTypes = "char" | "symbol"
local function getInvalidTypeName(invalidComponent: string): InvalidTypes
	local typePatterns: { [InvalidTypes]: string } = {
		char = "%a",
		symbol = "%p",
	}

	local presentType: InvalidTypes

	for type: InvalidTypes, pattern in typePatterns do
		if string.match(invalidComponent, pattern) then
			presentType = type
			break
		end
	end

	return presentType
end

local Semver = {}

export type SemverImpl = typeof(setmetatable({} :: Version, Semver))

export type PreleaseType = "alpha" | "beta" | "rc"

export type PrereleaseVersion = {
	type: PreleaseType,
	ordinal: Option<number>,
}

export type Version = {
	major: number,
	minor: number,
	patch: number,
	buildMetadata: Option<string>,
	prerelease: Option<PrereleaseVersion>,
}

export type SemverResult<T, E = SemverError> = Result<T, E>
export type SemverError = {
	msg: Option<string>,
	kind: SemverErrorKind,
}
export type SemverErrorKind = ParseError | {}
export type ParseError =
	{ id: "MandatoryComponentMissing", components: { string } }
	| {
		id: "InvalidComponentType",
		component: "major" | "minor" | "patch",
		expected: "number",
		got: "char" | "symbol" | "unknown",
	}
	| { id: "LeadingZerosPresent", component: "major" | "minor" | "patch" }
	| { id: "InvalidIdentifierCharacter", component: "prerelease" | "metadata" }
	| { id: "InvalidPrereleaseType", component: "prerelease", type: string }
	| { id: "InvalidPrereleaseOrdinalType", expected: "number", got: "char" | "symbol" }

local PRERELEASE_LEX_ORDER: { [PreleaseType]: number } = {
	alpha = 1,
	beta = 2,
	rc = 3,
}

function Semver.parse(ver: string): SemverResult<SemverImpl>
	local components = string.split(ver, ".")
	if #components < 3 then
		return Result.Err({
			msg = Option.Some(`Expected MAJOR.MINOR.PATCH format, missing {#components} / 3 components`),
			kind = {
				id = "MandatoryComponentMissing",
				components = components,
			} :: ParseError,
		} :: SemverError)
	end

	local patchStr, ext = string.match(components[3], "(%d+)([-+]?.*)")
	if patchStr == nil then
		return Result.Err({
			msg = Option.Some(`Expected patch to be only a number`),
			kind = {
				id = "InvalidComponentType",
				expected = "number",
				got = getInvalidTypeName(components[3]),
				component = "patch",
			} :: ParseError,
		} :: SemverError)
	end

	local major, minor, patch = tonumber(components[1]), tonumber(components[2]), tonumber(patchStr)
	if major == nil or minor == nil or patch == nil then
		local invalidComponentType: "major" | "minor" | "patch", invalidComponent: string

		if major == nil then
			invalidComponentType, invalidComponent = "major", components[1]
		elseif minor == nil then
			invalidComponentType, invalidComponent = "minor", components[2]
		elseif patch == nil then
			invalidComponentType, invalidComponent = "patch", patchStr :: string
		end

		local presentType: InvalidTypes = getInvalidTypeName(invalidComponent)
		return Result.Err({
			msg = Option.Some(
				`Expected {string.upper(invalidComponentType)} to be only a number, but got {presentType}`
			),
			kind = {
				id = "InvalidComponentType",
				expected = "number",
				got = presentType,
				component = invalidComponentType,
			} :: ParseError,
		} :: SemverError)
	end

	-- All components were valid numbers, but we check to see if they had any leading zeros
	-- Leading zeros are invalid in semver
	local majorLeadingZeros = doLeadingZeroesCheck("major", components[1])
	if majorLeadingZeros:isErr() then
		return majorLeadingZeros
	end

	local minorLeadingZeros = doLeadingZeroesCheck("minor", components[2])
	if minorLeadingZeros:isErr() then
		return minorLeadingZeros
	end

	local patchLeadingZeros = doLeadingZeroesCheck("patch", patchStr)
	if patchLeadingZeros:isErr() then
		return patchLeadingZeros
	end

	local parsed: Version = {
		major = major :: number,
		minor = minor :: number,
		patch = patch :: number,
		buildMetadata = Option.None :: Option<string>,
		prerelease = Option.None :: Option<PrereleaseVersion>,
	}

	if ext ~= nil then
		if stringStartsWith(ext, "-") then
			-- Prerelease information
			local prereleaseType = string.sub(ext, 2)
			if prereleaseType ~= "alpha" and prereleaseType ~= "beta" and prereleaseType ~= "rc" then
				return Result.Err({
					msg = Option.Some(`Expected prerelease type to be alpha | beta | rc, but got {prereleaseType}`),
					kind = {
						id = "InvalidPrereleaseType",
						component = "prerelease",
						type = prereleaseType,
					} :: ParseError,
				} :: SemverError)
			end

			local function badPrereleaseType(prerelease: string): SemverResult<SemverImpl>
				local invalidType: InvalidTypes = getInvalidTypeName(prerelease)
				return Result.Err({
					msg = Option.Some(`Expected PRERELEASE to only be a number, but got {invalidType}`),
					kind = {
						id = "InvalidPrereleaseOrdinalType",
						expected = "number",
						got = invalidType,
					} :: ParseError,
				} :: SemverError)
			end

			local prereleaseOrdinal = Option.None :: Option<number>

			-- TODO: Cleanup this recovery logic of recomputing a bit more, maybe remove it entirely
			if components[4] ~= nil then
				local ordinalNum = tonumber(components[4])
				if ordinalNum == nil then
					-- If it wasn't a valid number for the ordinal, that must mean one of two things:
					-- a) The PRERELEASE component was bad
					-- b) The component has build metadata after prerelease info
					-- Here, we handle both those cases

					local potentialOrdinalNumber, potentialBuildMetadata = string.match(components[4], "(%d)+(.*)")
					if potentialOrdinalNumber == nil then
						return badPrereleaseType(components[4])
					end

					if potentialBuildMetadata ~= nil then
						local fullBuildMetadata = potentialBuildMetadata
						for i = 5, #components do
							fullBuildMetadata ..= "." .. components[i]
						end

						parsed.buildMetadata = Option.Some(fullBuildMetadata :: string) :: Option<string>
					end

					if potentialOrdinalNumber ~= nil then
						ordinalNum = tonumber(potentialOrdinalNumber)
						if ordinalNum == nil then
							return badPrereleaseType(components[4])
						end
					end
				end

				prereleaseOrdinal = Option.Some(ordinalNum :: number) :: Option<number>
			end

			parsed.prerelease = Option.Some({
				type = prereleaseType,
				ordinal = prereleaseOrdinal,
			} :: PrereleaseVersion) :: Option<PrereleaseVersion>
		end

		if stringStartsWith(ext, "+") then
			-- Build metadata information; we remove the leading `+` symbol and add
			-- the rest of the components to the build metadata
			local fullBuildMetadata = string.sub(ext, 2)
			for i = 4, #components do
				fullBuildMetadata ..= "." .. components[i]
			end

			parsed.buildMetadata = Option.Some(fullBuildMetadata) :: Option<string>
		end
	end

	return Result.Ok(setmetatable(parsed :: Version, Semver))
end

local function prereleaseEq(leftPrerelease: PrereleaseVersion?, rightPrerelease: PrereleaseVersion?): boolean
	if leftPrerelease == nil and rightPrerelease == nil then
		return true
	end

	if leftPrerelease == nil or rightPrerelease == nil then
		return false
	end

	return leftPrerelease.type == rightPrerelease.type and leftPrerelease.ordinal == rightPrerelease.ordinal
end

local function prereleaseLt(leftPrerelease: PrereleaseVersion?, rightPrerelase: PrereleaseVersion?): boolean
	if not prereleaseEq(leftPrerelease, rightPrerelase) then
		if leftPrerelease ~= nil and rightPrerelase ~= nil then
			if leftPrerelease.type == rightPrerelase.type then
				return leftPrerelease.ordinal:unwrapOr(0) < rightPrerelase.ordinal:unwrapOr(0)
			end

			return PRERELEASE_LEX_ORDER[leftPrerelease.type] < PRERELEASE_LEX_ORDER[rightPrerelase.type]
		end

		return not (leftPrerelease == nil and rightPrerelase ~= nil)
			and (leftPrerelease ~= nil and rightPrerelase == nil)
	end

	return false
end

local function prereleaseLe(leftPrerelease: PrereleaseVersion?, rightPrerelase: PrereleaseVersion?): boolean
	return prereleaseLt(leftPrerelease, rightPrerelase) or prereleaseEq(leftPrerelease, rightPrerelase)
end

function Semver.__eq(left: SemverImpl, right: SemverImpl): boolean
	return left.major == right.major
		and left.minor == right.minor
		and left.patch == right.patch
		and prereleaseEq(left.prerelease:unwrapOrNil(), right.prerelease:unwrapOrNil())
end

function Semver.__lt(left: SemverImpl, right: SemverImpl): boolean
	return if left.major ~= right.major
		then left.major < right.major
		elseif left.minor ~= right.minor then left.minor < right.minor
		elseif left.patch ~= right.patch then left.patch < right.patch
		else prereleaseLt(left.prerelease:unwrapOrNil(), right.prerelease:unwrapOrNil())
end

function Semver.__le(left: SemverImpl, right: SemverImpl): boolean
	return if left.major ~= right.major
		then left.major <= right.major
		elseif left.minor ~= right.minor then left.minor <= right.minor
		elseif left.patch ~= right.patch then left.patch <= right.patch
		else prereleaseLe(left.prerelease:unwrapOrNil(), right.prerelease:unwrapOrNil())
end
return Semver
