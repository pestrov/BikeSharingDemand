dataSetSize = size(datesData);

hoursInDay = 24;
hourlySum = zeros(hoursInDay,1);
hourlyEntries = zeros(hoursInDay,1);

weathersSum = zeros(4,1);
weathersEntries = zeros(4,1);

tempSum = zeros(42,1);
tempEntries = zeros(42,1);

for dataPoint = 1:dataSetSize
    
    %Hours ? Main Trend
    dataPointHour = hourFromDate(datesData{dataPoint});
    hourlySum(dataPointHour) = hourlySum(dataPointHour) + count(dataPoint);
    hourlyEntries(dataPointHour) = hourlyEntries(dataPointHour)+1;
    
    %Seasons
    
    %Weather
    dataPointWeather = weather(dataPoint);
    weathersSum(dataPointWeather) = weathersSum(dataPointWeather) + count(dataPoint);
    weathersEntries(dataPointWeather) = weathersEntries(dataPointWeather)+1;
    
    %Temperature
    dataPointTemp = floor(temp(dataPoint)) + 1;
    tempSum(dataPointTemp) = tempSum(dataPointTemp) + count(dataPoint);
    tempEntries(dataPointTemp) = tempEntries(dataPointTemp)+1;
    
    
end

hourlyMeans = floor(hourlySum./hourlyEntries);
weatherMeans = floor(weathersSum./weathersEntries)
tempMeans = floor(tempSum./tempEntries)

testDataSetSize = size(testDatesData);

answerCount = zeros(testDataSetSize);

for i = 1:testDataSetSize
    answerCount(i) = hourlyMeans(hourFromDate(testDatesData{i}));
end

