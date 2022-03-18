function [ObjFun] = ObjFun_fun(X, Data)
n = length(Data.Z(:,1));
Z = zeros(n,1);
for k = 1:1:n
    Z(k,1) = Data.Function(X, Data.X(k,:));
end
SSE = 0;
for k = 1:1:n
    SSE = SSE + (Z(k,1) - Data.Z(k,1))^2;
end
ObjFun = SSE;
end