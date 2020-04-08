return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local isNaN = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("isNaN"))

	describe("isNaN", function()
		it("should recognize nan correctly", function()
			expect(isNaN(0 / 0)).to.equal(true)
		end)

		it("should recognize non-nan correctly", function()
			expect(isNaN(function() end)).to.equal(false)
			expect(isNaN({})).to.equal(false)
			expect(isNaN("hello, world")).to.equal(false)
			expect(isNaN(1)).to.equal(false)
			expect(isNaN(math.huge)).to.equal(false)
			expect(isNaN(nil)).to.equal(false)
			expect(isNaN(false)).to.equal(false)
			expect(isNaN(true)).to.equal(false)
		end)
	end)
end
