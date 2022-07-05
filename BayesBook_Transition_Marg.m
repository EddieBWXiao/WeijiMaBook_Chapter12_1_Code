function BayesBook_Transition_Marg(upost,sigpost, delta,sigma_s)

%Visualising the transition function & marginalisation
%in 12.1.2 of Weiji Ma's book

%upost: mean of the posterior in t-1, to be turned into prior
%sigpost: standard deviation of the posterior in t-1
%delta: property of the transition function
    % (increase by delta units per unit time)
%sigma_s: the "uncertainty" of delta (transition not deterministic)

%example use: BayesBook_Transition_Marg(1,1,4,1)

xgrid = -10:0.05:10;

%% the posterior from the previous update
post = normpdf(xgrid,upost,sigpost);

subplot(3,1,1)
plot(xgrid,post)
xlabel('s(t-1)')
ylabel('probability densitiy')

%% the transition function (loop through possible value combinations)
transf = nan(length(xgrid),length(xgrid));
for i = 1:length(transf)
    for j = 1:length(transf)
        transf(i,j) = normpdf(xgrid(i),...
            xgrid(j)+delta,...
            sigma_s);
    end
end
subplot(3,1,2)
imagesc(xgrid,xgrid,transf)
axis square
ylabel('s(t)')
xlabel('s(t-1)')

%% the new prior: create by multiplication, then marginalise 
postgrid = repmat(post,[length(xgrid),1]);
prodgrid = transf.*postgrid;
%prodgrid = prodgrid/sum(prodgrid,'all');
newprior = sum(prodgrid,2);%sum each row (over s(t-1))

subplot(3,1,3)
plot(xgrid,newprior)
xlabel('s(t)')
ylabel('probability densitiy')

%% visualise the two grids
%the grid that expands the posterior
figure;
subplot(3,1,1)
subplot(3,1,2)
imagesc(xgrid,xgrid,postgrid)
axis square
xlabel('s(t-1)')
subplot(3,1,3)

%grid for the "stuff" before marginalising over s(t-1) 
figure;
subplot(3,1,1)
subplot(3,1,2)
imagesc(xgrid,xgrid,prodgrid)
axis square
%xlabel('s(t-1)')
%ylabel('s(t)')
subplot(3,1,3)

end