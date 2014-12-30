%function trainParameters()

C = zeros(dataSetSize);
d = zeros(dataSetSize);

for dataPoint = 1:dataSetSize
    hour = hourFromDate(datesData{dataPoint});
    %Temperature
    C(dataPoint) = atemp(dataPoint) - hourlyTempMeans(hour);
    d(dataPoint) = count(dataPoint) - hourlyMeans(hour);
    
end

tempCoeff = lsqnonneg(C,d);