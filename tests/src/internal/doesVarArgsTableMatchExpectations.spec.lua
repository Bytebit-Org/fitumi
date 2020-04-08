return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local wildcard = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("symbols"):WaitForChild("wildcard"))
	local doesVarArgsTableMatchExpectations = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("doesVarArgsTableMatchExpectations"))

	local function createVarArgsTable(...)
		return { length = select("#", ...), ... }
	end

	describe("doesVarArgsTableMatchExpectations", function()
		it("should recognize equivalent tables with simple values", function()
			local actual = createVarArgsTable(true, 2, "three")
			local expected = createVarArgsTable(true, 2, "three")

			expect(doesVarArgsTableMatchExpectations(actual, expected)).to.equal(true)
		end)

		it("should recognize equivalent tables with NaNs", function()
			local actual = createVarArgsTable(true, 0 / 0, "three")
			local expected = createVarArgsTable(true, 0 / 0, "three")

			expect(doesVarArgsTableMatchExpectations(actual, expected)).to.equal(true)
		end)

		it("should recognize equivalent tables when expecting wildcards", function()
			local actual = createVarArgsTable(true, 2, "three")
			local expected = createVarArgsTable(true, wildcard, "three")

			expect(doesVarArgsTableMatchExpectations(actual, expected)).to.equal(true)
		end)

		it("should throw when given invalid inputs", function()
			local invalidInput = {}
			local validInput = createVarArgsTable(true, 2, "three")

			expect(function()
				doesVarArgsTableMatchExpectations(validInput, invalidInput)
			end).to.throw()

			expect(function()
				doesVarArgsTableMatchExpectations(invalidInput, validInput)
			end).to.throw()

			expect(function()
				doesVarArgsTableMatchExpectations(invalidInput, invalidInput)
			end).to.throw()
		end)

		it("should recognize non-equivalent tables when of different lengths", function()
			local shorter = createVarArgsTable(true, 2)
			local longer = createVarArgsTable(true, 2, "three")

			expect(doesVarArgsTableMatchExpectations(shorter, longer)).to.equal(false)
			expect(doesVarArgsTableMatchExpectations(longer, shorter)).to.equal(false)
		end)

		it("should recognize non-equivalent tables when of different values", function()
			local actual = createVarArgsTable(false, -2, "not three")
			local expected = createVarArgsTable(true, 2, "three")

			expect(doesVarArgsTableMatchExpectations(actual, expected)).to.equal(false)
		end)

		it("should recognize non-equivalent tables when NaN is in actual but not expected", function()
			local actual = createVarArgsTable(true, 0 / 0, "three")
			local expected = createVarArgsTable(true, 2, "three")

			expect(doesVarArgsTableMatchExpectations(actual, expected)).to.equal(false)
		end)

		it("should recognize non-equivalent tables when wildcard is in actual but not expected", function()
			local actual = createVarArgsTable(wildcard, wildcard, wildcard)
			local expected = createVarArgsTable(true, 2, "three")

			expect(doesVarArgsTableMatchExpectations(actual, expected)).to.equal(false)
		end)
	end)
end
