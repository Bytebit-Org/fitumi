return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local fitumi = require(ReplicatedStorage:WaitForChild("fitumi"))

	describe("fitumi entry", function()
		it("should provide the expected key/value pairs", function()
			expect(fitumi.a).to.be.a("table")
			expect(fitumi.clearCallHistory).to.be.a("function")
			expect(fitumi.clearWriteHistory).to.be.a("function")
			expect(fitumi.wildcard).to.be.a("table")
		end)
	end)
end
