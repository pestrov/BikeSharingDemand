dataSetSize = size(datesData);

hoursInDay = 24;
hourlySum = zeros(hoursInDay,1);
hourlyEntries = zeros(hoursInDay,1);

hourlyTempSum = zeros(hoursInDay,1);

weathersSum = zeros(4,1);
weathersEntries = zeros(4,1);

tempSum = zeros(42,1);
tempEntries = zeros(42,1);

for dataPoint = 1:dataSetSize
    
    %Hours ? Main Trend
    dataPointHour = hourFromDate(datesData{dataPoint});
    hourlySum(dataPointHour) = hourlySum(dataPointHour) + count(dataPoint);
    hourlyEntries(dataPointHour) = hourlyEntries(dataPointHour)+1;

    %Hourly mean temperature
    hourlyTempSum(dataPointHour) = hourlyTempSum(dataPointHour) + atemp(dataPoint);

    %Seasons
    
    %Weather
    dataPointWeather = weather(dataPoint);
    weathersSum(dataPointWeather) = weathersSum(dataPointWeather) + count(dataPoint);
    weathersEntries(dataPointWeather) = weathersEntries(dataPointWeather)+1;
    
    %Temperature
    dataPointTemp = floor(temp(dataPoint)) + 1;
    tempSum(dataPointTemp) = tempSum(dataPointTemp) + count(dataPoint);
    tempEntries(dataPointTemp) = tempEntries(dataPointTemp)+1;
    
   %Check if registred ride more on weekdays
    if (workingday(dataPoint) == 1)
        workingSumRegistered = workingSumRegistered + registered(dataPoint);
        workingSumCasual = workingSumCasual + casual(dataPoint);
        workingEntries = workingEntries + 1;
    else
        restSumRegistered = restSumRegistered + registered(dataPoint);
        restSumCasual = restSumCasual + casual(dataPoint);
        restEntries = restEntries + 1;
    end
    
end

restAverageRegister = restSumRegistered/restEntries;
restAverageCasual = restSumCasual/restEntries;

workingAverageRegister = workingSumRegistered/workingEntries;
workingAverageCasual = workingSumCasual/workingEntries;

hourlyMeans = hourlySum./hourlyEntries;
hourlyTempMeans = hourlyTempSum./hourlyEntries;
weatherMeans = floor(weathersSum./weathersEntries);
tempMeans = floor(tempSum./tempEntries);

%Training
trainParameters;

%Printing the result
testDataSetSize = size(testDatesData);
answerCount = zeros(testDataSetSize);

baaadAnswer = 0;
for i = 1:testDataSetSize
    hour = hourFromDate(testDatesData{i});
    answerCount(i) = hourlyMeans(hourFromDate(testDatesData{i})) + tempCoeff*...
        (testatemp(i)-hourlyTempMeans(hour));
    if answerCount(i) < 0
        answerCount(i) = 0  ;
    end
end

answerCount = floor(answerCount);

