k = 50;

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

month = zeros(dataSetSize);
for i=1:dataSetSize
    month(i)=monthFromDate(datesData{i});
end

testMonth = zeros(testDataSetSize);
for i=1:testDataSetSize
    testMonth(i)=monthFromDate(testDatesData{i});
end

day = zeros(dataSetSize);
for i=1:dataSetSize
    day(i)=weekday(datesData{i});
end

testDay = zeros(testDataSetSize);
for i=1:testDataSetSize
    testDay(i)=weekday(testDatesData{i});
end

w = [1,45,20,40,20,50,1,0,0,0];
tic
for i=1:testDataSetSize
    kMinRadius = ones(k,1).*10000;
    kMinNeighbours = zeros(k,1);
    
    for j=1:dataSetSize
        
        if testHour(i) ~= hour(j)
            continue
        end
        
        radius = ...
           w(10)*(temp(j)-temp1(i))^2+...
           w(1)*(atemp(j)-testatemp(i))^2+...
           w(9)*(windspeed(j)-windspeed1(i))^2+...
           w(8)*(humidity(j)-humidity1(i))^2+...
           w(4)*(weather(j)~=weather1(i))+...
           w(2)*(workingday(j)~=workingday1(i))+...
           w(6)*(holiday(j)~=holiday1(i))+...
           w(5)*(season(j)~=season1(i))+...
           w(7)*(month(j)~=testMonth(i))+...;
           w(3)*(day(j)~=testDay(i));
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
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % neighbour weight is 1
    
    %answerCount(i) = floor(sum(count(kMinNeighbours))/k); 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % neighbour weight is (k+1-i)/k
%     sum = 0;
%     sumWeights = 0;
%     for index=1:k
%         weight = (k+1-index)/k;
%         sum = sum + weight*count(kMinNeighbours(index));
%         sumWeights = sumWeights + weight;
%     end
%     answerCount(i) = sum/sumWeights;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % neighbour weight is q^i
    q = 0.7;
    weight = 1;
    sum = 0;
    sumWeights = 0;
    for index=1:k
        sum = sum + weight*count(kMinNeighbours(index));
        sumWeights = sumWeights + weight;
        weight = weight*q;
    end
    answerCount(i) = sum/sumWeights;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % neighbour weight is reverse proportional to the radius
    
%     meanRadius = mean(kMinRadius);
%     if meanRadius == 0
%         answerCount(i) = floor(sum(count(kMinNeighbours))/k);
%     else
%         meanCountSum = 0;
%         weightsSum = 0;
%         for neighboor = 1:k
%             meanCountSum = meanCountSum + count(kMinNeighbours(neighboor)) * (1 - kMinRadius(neighboor)/meanRadius)^2;
%             weightsSum = weightsSum + (1 - kMinRadius(neighboor)/meanRadius)^2;
%         end
%         answerCount(i) = meanCountSum/weightsSum;
%     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end
answerCount = round(answerCount); 
toc