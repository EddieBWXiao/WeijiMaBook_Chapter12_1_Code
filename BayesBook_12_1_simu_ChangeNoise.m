function BayesBook_12_1_simu_ChangeNoise

%following the simple generative model in chapter 12
%where delta and sigma_s determine the transition function
%(a process that increases with time)

%examine the effect of having different sigma values:
%(i.e., different measurement noise)

%the list of sigma:
sigma_list = [1,10,25,50]; %of mapping s to x

for i = 1:length(sigma_list)
    ntrials = 20;
    delta = 4;
    sigma_s = 1; %of s(t-1) to s(t)
    sigma = sigma_list(i);
    
    %% "generative model" (create the observations)
    for t = 1:ntrials
        if t == 1
            s(t) = normrnd(-5,5); %starting point
        else
            s(t) = normrnd(s(t-1)+delta,sigma_s); %transition
        end

        %generate observations
        x(t) = normrnd(s(t),sigma);

    end

    %% create a Bayesian learner that knows delta etc., and infers s
    for t = 1:ntrials

        %setting up the prior, miu(t) NOT the final miu(t)
        if t == 1
            %starting point
            miu(t) = -5; %mean estimated
            estsig(t) = 5; %the uncertainty of the estimator
        else
            miu(t) = miu(t-1)+delta; %transition
            estsig(t) = sqrt(estsig(t-1)^2+sigma_s^2); %variance increase
        end

        %precision-weighted integration of observation
        toolong = x(t)/sigma^2 + miu(t)/estsig(t)^2;
        miu(t) = (toolong)/((1/sigma^2)+(1/estsig(t)^2));
        estsigma(t) = sqrt(1/(1/sigma^2)+(1/estsig(t)^2));
    end

    %% visualise for each noise level
    subplot(2,2,i)
    plot(s,'-')
    hold on
    plot(x,'ko')
    plot(miu,'r--')
    hold off
    xlabel('time')
    ylabel('magnitude')
    legend('s_t','x_t','miu_t','Location','Northwest')
    title(sprintf('sigma = %i',sigma))

end
end