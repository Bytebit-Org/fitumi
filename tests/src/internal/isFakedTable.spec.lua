return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local internalsSymbol = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("internalsSymbol"))
	local isFakedTable = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("isFakedTable"))

	describe("isFakedTable", function()
		it("should recognize a faked table correctly", function()
			expect(isFakedTable({
				[internalsSymbol] = {}
			})).to.equal(true)
		end)

		it("should recognize counter-examples correctly", function()
			expect(isFakedTable(function() end)).to.equal(false)
			expect(isFakedTable({})).to.equal(false)
			expect(isFakedTable({
				[internalsSymbol] = function() end
			})).to.equal(false)
			expect(isFakedTable("hello, world")).to.equal(false)
			expect(isFakedTable(1)).to.equal(false)
			expect(isFakedTable(math.huge)).to.equal(false)
			expect(isFakedTable(nil)).to.equal(false)
			expect(isFakedTable(false)).to.equal(false)
			expect(isFakedTable(true)).to.equal(false)
		end)
	end)
end
