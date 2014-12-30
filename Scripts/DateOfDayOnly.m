dataSetSize = size(datesData);

hoursInDay = 24;
hourlySum = zeros(hoursInDay,1);
hourlyEntries = zeros(hoursInDay,1);

for dataPoint = 1:dataSetSize
    dataPointHour = hourFromDate(datesData{dataPoint});
    hourlySum(dataPointHour) = hourlySum(dataPointHour) + count(dataPoint);
    hourlyEntries(dataPointHour) = hourlyEntries(dataPointHour)+1;
end

hourlyMeans = floor(hourlySum./hourlyEntries);

testDataSetSize = size(testDatesData);

answerCount = zeros(testDataSetSize);

for i = 1:testDataSetSize
    answerCount(i) = hourlyMeans(hourFromDate(testDatesData{i}));
end
