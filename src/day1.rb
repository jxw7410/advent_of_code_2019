def calculateFuel(mass)
  mass / 3 - 2 
end

def calculateTotalFuelRequirement( dataSample )
  dataSample.reduce(0){|sum, mass| sum + calculateFuel(mass)}
end


