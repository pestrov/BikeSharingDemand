%function trainParameters()

C = zeros(dataSetSize);
d = zeros(dataSetSize);

for dataPoint = 1:dataSetSize
       
    %Temperature
    C(dataPoint) = hourlyMeans(hourFromDate(datesData{dataPoint}))*atemp(dataPoint);
    d(dataPoint) = count(dataPoint);
    
end

tempCoeff = lsqnonneg(C,d);