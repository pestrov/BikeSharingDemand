k = 5;

dataSetSize = size(datesData);

testDataSetSize = size(testDatesData);

answerCount = zeros(testDataSetSize);

hour = zeros(dataSetSize);
for i=1:dataSetSize
    hour(i)=hourFromDate(datesData{i});
end

testHour = zeros(testDataSetSize);
for i=1:testDataSetSize
    testHour(i)=hourFromDate(testDatesData{i});
end

tic
for i=1:testDataSetSize
    kMinRadius = ones(k,1).*100;
    kMinNeighbours = zeros(k,1);
    
    for j=1:dataSetSize
        
        if testHour(i) ~= hour(j)
            continue
        end
        
        radius = ((temp(j)-temp1(i))/41)^2+...
            ((atemp(j)-testatemp(i))/45)^2+...
            ((windspeed(j)-windspeed1(i))/57)^2+...
            ((humidity(j)-humidity1(i))/100)^2+...
            (weather(j)~=weather1(i))+...
            (workingday(j)~=workingday1(i))+...
            (holiday(j)~=holiday1(i))+...
            (season(j)~=season1(i));
        index = k;
        while (radius < kMinRadius(index))
            temprad = kMinRadius(index);
            tempind = kMinNeighbours(index);
            kMinRadius(index) = radius;
            kMinNeighbours(index) = j;
            if index<k
                kMinRadius(index+1) = temprad;
                kMinNeighbours(index+1) = tempind;
            end
            index = index-1;
            if index == 0
                break
            end
        end    
    end
  
    meanRadius = mean(kMinRadius);
    if meanRadius == 0
        answerCount(i) = floor(sum(count(kMinNeighbours))/k);
    else
        meanCountSum = 0;
        weightsSum = 0;
        for neighboor = 1:k
            meanCountSum = meanCountSum + count(kMinNeighbours(neighboor)) * (1 - kMinRadius(neighboor)/meanRadius)^2;
            weightsSum = weightsSum + (1 - kMinRadius(neighboor)/meanRadius)^2;
        end
        answerCount(i) = floor(meanCountSum/weightsSum);
    end
    
end
toc