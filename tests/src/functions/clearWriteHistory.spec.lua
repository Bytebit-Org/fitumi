return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local clearWriteHistory = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("functions"):WaitForChild("clearWriteHistory"))
	local internalsSymbol = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("internalsSymbol"))

	describe("clearWriteHistory", function()
		it("should not error with valid input", function()
			local fakedTable = {
				[internalsSymbol] = {}
			}

			expect(function()
				clearWriteHistory(fakedTable)
			end).never.to.throw()
		end)

		it("should error when given an invalid input", function()
			expect(function()
				clearWriteHistory(nil)
			end).to.throw()
			expect(function()
				clearWriteHistory(false)
			end).to.throw()
			expect(function()
				clearWriteHistory(true)
			end).to.throw()
			expect(function()
				clearWriteHistory(0)
			end).to.throw()
			expect(function()
				clearWriteHistory(1)
			end).to.throw()
			expect(function()
				clearWriteHistory(math.huge)
			end).to.throw()
			expect(function()
				clearWriteHistory("hello, world")
			end).to.throw()
			expect(function()
				clearWriteHistory(function() end)
			end).to.throw()
			expect(function()
				clearWriteHistory({})
			end).to.throw()
		end)

		it("should clear write history for only the given completely when a key is provided", function()
			local fakedTable = {
				[internalsSymbol] = {
					writeHistory = {
						key = {
							"value"
						},
						otherKey = {
							"otherValue"
						}
					}
				}
			}

			clearWriteHistory(fakedTable, "key")

			expect(fakedTable[internalsSymbol].writeHistory["key"]).never.to.be.ok()
			expect(fakedTable[internalsSymbol].writeHistory["otherKey"]).to.be.ok()
			expect(#fakedTable[internalsSymbol].writeHistory["otherKey"]).to.equal(1)
			expect(fakedTable[internalsSymbol].writeHistory["otherKey"][1]).to.equal("otherValue")
		end)

		it("should clear write history completely when not given a key", function()
			local fakedTable = {
				[internalsSymbol] = {
					writeHistory = {
						key = {
							"value"
						},
						otherKey = {
							"otherValue"
						}
					}
				}
			}

			clearWriteHistory(fakedTable)

			expect(fakedTable[internalsSymbol].writeHistory["key"]).never.to.be.ok()
			expect(fakedTable[internalsSymbol].writeHistory["otherKey"]).never.to.be.ok()
		end)
	end)
end
