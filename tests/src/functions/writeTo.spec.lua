return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local writeTo = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("functions"):WaitForChild("writeTo"))
	local internalsSymbol = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("internalsSymbol"))

	describe("writeTo", function()
		it("should return the expected set of methods", function()
			local fakedTable = {
				[internalsSymbol] = {}
			}

			local result = writeTo(fakedTable)
			expect(result).to.be.ok()
			expect(result).to.be.a("table")
			expect(result["didHappen"]).to.be.a("function")
			expect(result["didNotHappen"]).to.be.a("function")
		end)

		it("should error when given an invalid input", function()
			expect(function()
				writeTo(nil)
			end).to.throw()
			expect(function()
				writeTo(false)
			end).to.throw()
			expect(function()
				writeTo(true)
			end).to.throw()
			expect(function()
				writeTo(0)
			end).to.throw()
			expect(function()
				writeTo(1)
			end).to.throw()
			expect(function()
				writeTo(math.huge)
			end).to.throw()
			expect(function()
				writeTo("hello, world")
			end).to.throw()
			expect(function()
				writeTo(function() end)
			end).to.throw()
			expect(function()
				writeTo({})
			end).to.throw()
		end)

		it("should report that a write happened correctly", function()
			local fakedTable = {
				[internalsSymbol] = {
					writeHistory = {
						key = {
							"value"
						}
					}
				}
			}

			expect(writeTo(fakedTable, "notkey", "value"):didHappen()).to.equal(false)
			expect(writeTo(fakedTable, "key", "notvalue"):didHappen()).to.equal(false)
			expect(writeTo(fakedTable, "key", "value"):didHappen()).to.equal(true)
		end)

		it("should report that a write did not happen correctly", function()
			local fakedTable = {
				[internalsSymbol] = {
					writeHistory = {
						key = {
							"value"
						}
					}
				}
			}

			expect(writeTo(fakedTable, "notkey", "value"):didNotHappen()).to.equal(true)
			expect(writeTo(fakedTable, "key", "notvalue"):didNotHappen()).to.equal(true)
			expect(writeTo(fakedTable, "key", "value"):didNotHappen()).to.equal(false)
		end)
	end)
end
