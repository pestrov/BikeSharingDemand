dataSetSize = size(datesData);

hoursInDay = 24;
hourlySum = zeros(hoursInDay,1);
hourlyEntries = zeros(hoursInDay,1);

for dataPoint = 1:dataSetSize
    dataPointHour = hourFromDate(datesData{dataPoint});
    hourlySum(dataPointHour) = hourlySum(dataPointHour) + count(dataPoint);
    hourlyEntries(dataPointHour) = hourlyEntries(dataPointHour)+1;
end
hourlySum

hourlyMeans = floor(hourlySum./hourlyEntries)