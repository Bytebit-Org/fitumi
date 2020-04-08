return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local varArgsToTable = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("varArgsToTable"))

	describe("varArgsToTable", function()
		it("should calculate length correctly", function()
			local zero = varArgsToTable()
			local one = varArgsToTable(true)
			local three = varArgsToTable(true, 2, "three")

			expect(zero.length).to.equal(0)
			expect(one.length).to.equal(1)
			expect(three.length).to.equal(3)
		end)

		it("should record inputs accurately", function()
			local one = varArgsToTable(true)
			local three = varArgsToTable(true, 2, "three")

			expect(one[1]).to.equal(true)
			expect(three[1]).to.equal(true)
			expect(three[2]).to.equal(2)
			expect(three[3]).to.equal("three")
		end)
	end)
end
