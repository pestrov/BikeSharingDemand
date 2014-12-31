k = 50;

dataSetSize = size(datesData);

hour = zeros(dataSetSize);
for i=1:dataSetSize
    hour(i)=hourFromDate(datesData{i});
end

month = zeros(dataSetSize);
for i=1:dataSetSize
    month(i)=monthFromDate(datesData{i});
end

day = zeros(dataSetSize);
for i=1:dataSetSize
    day(i)=weekday(datesData{i});
end


w = [0,0.04,0,0,1,2,1,1,0,1];
sumLogarithmicError = 0;
tic
for i=1:dataSetSize
    kMinRadius = ones(k,1).*100;
    kMinNeighbours = zeros(k,1);
    
    for j=1:dataSetSize
        
        if (hour(i) ~= hour(j))||(i==j)
            continue
        end
        
        radius = ...
            w(1)*(temp(j)-temp(i))^2+...
            w(2)*(atemp(j)-atemp(i))^2+...
            w(3)*(windspeed(j)-windspeed(i))^2+...
            w(4)*(humidity(j)-humidity(i))^2+...
            w(5)*(weather(j)~=weather(i))+...
            w(6)*(workingday(j)~=workingday(i))+...
            w(7)*(holiday(j)~=holiday(i))+...
            w(8)*(season(j)~=season(i))+...
            w(9)*(month(j)~=month(i))+...;
            w(10)*(day(j)~=day(i));
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
    
    %answerCount = round(sum(count(kMinNeighbours))/k); 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % neighbour weight is (k+1-i)/k
%     sum = 0;
%     sumWeights = 0;
%     for index=1:k
%         weight = (k+1-index)/k;
%         sum = sum + weight*count(kMinNeighbours(index));
%         sumWeights = sumWeights + weight;
%     end
%     answerCount = round(sum/sumWeights);

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
    answerCount = round(sum/sumWeights);
    
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
    
    logarithmicError = (log(answerCount+1)-log(count(i)+1))^2;
    sumLogarithmicError = sumLogarithmicError + logarithmicError;

end
RMSLE = sqrt(sumLogarithmicError/dataSetSize(1))
toc