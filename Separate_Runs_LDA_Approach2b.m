%% LDA Approach #2b

% LDA Approach #2b - Sliding Window Analysis (used to "...predict dPCA component"):  
%  a) Leave-One-Out Cross Validation. 
%  b) Permutation Tests.
%  c) LDA not Logistic Regression. 

%tic

for i = 1:20
    eval(['load EEG_', num2str(i), 'a.mat dataA EEGa ;']) % Loading trial information (including Stimulus Labels) + EEG Information (Channels x Timepoints x Trials)
    eval(['load dpca_results_', num2str(i), 'a.mat W whichMarg time ;'])

% -) Establishing Subjects' Behavioural Data Information (Used to classify experimental conditions for Stimulus Feature, Congruency, and Modality Switch Effect:
    trialinfo = dataA.trialinfo;
    
% -) Defining Projection Matrices: 
    [N_electrodes, N_timepoints, N_trials] = size(EEGa);
    pre_decoding_matrix = reshape(EEGa, N_electrodes,N_timepoints*N_trials); 
    projection_matrix = W' * pre_decoding_matrix; % Each component now has one waveform.
% -) Removing Time and Interaction dPCA Components: 
    projection_matrix_labels = whichMarg'; 
    projection_matrix(projection_matrix_labels>3,:)=[]; 
    projection_matrix_labels(projection_matrix_labels>3)=[]; 
% -) Reshaping Projection Matrices To Include Timepoint: 
    component_labels = length(projection_matrix_labels);
    time_projection_matrix = reshape(projection_matrix, component_labels,N_timepoints,N_trials); 
% -) Defining Classifier's Discriminant Labels:
    StimulusFeature_Labels = trialinfo(:,2); % 1 = High Pitch Tone, 2 = Low Pitch Tone
    Congruency_Labels = trialinfo(:,3); % 1 = Congruent, 2 = Incongruent
    ModalitySwitchEffect_Labels = trialinfo(:,10); % 1 = Same Modality, 2 = Different Modality ...than previous trial. 

    timepoints = time; % This will be the same across all participants.  

% i) Clarifying EEG Channels/Electrodes x Timepoints x Trials (Distinct from LDA Approach #1 + 2a):
    EEG_approach2b = EEGa; 
% ii) Establishing Counters for Stimulus Feature, Congruency, and Modality Switch Effect Conditions: 
    ee = 0; % Counter for Sliding Windows of 10ms for Stimulus Feature. 
    ff = 0; % Counter for Sliding Windows of 10ms for Congruency.
    gg = 0; % Counter for Sliding Windows of 10ms for Modality Switch Effect. 
%     Counters all start from 5th indexed timepoint.
%     Sliding Windows cover 10 timepoints = 10ms Sliding Windows. 
%     Separate Sliding Window Analyses for Stimulus Feature, Congruency, Modality Siwtch Effects: 
% iii) Creating Linear Discriminants using Sliding Window Analysis...
%     a) Stimulus Feature: 
    for e = 5:5:401-5
        ee = ee+1; 
        EEGwindow = reshape(EEG_approach2b(:,[e-4:e+5],:),128,10*N_trials);
        [Azloo2b_sf(:,ee,i),Azsig2b_sf(:,ee,i),Y2b_sf(:,ee,i),a2b_sf(:,ee,i),v2b_sf(:,ee,i),D2b_sf(:,i)] = single_trial_analysis(EEGwindow,StimulusFeature_Labels-1,10,0,[1 1000 0.05],[],0,1)
        e
    end
%     b) Congruency:
    for f = 5:5:401-5
        ff = ff+1;
        EEGwindow = reshape(EEG_approach2b(:,[f-4:f+5],:),128,10*N_trials);
        [Azloo2b_con(:,ff,i),Azsig2b_con(:,ff,i),Y2b_con(:,ff,i),a2b_con(:,ff,i),v2b_con(:,ff,i),D2b_con(:,i)] = single_trial_analysis(EEGwindow,Congruency_Labels-1,10,0,[1 1000 0.05],[],0,1)
        f
    end
%     c) Modality Switch Effect:
    for g = 5:5:401-5
        gg = gg+1;
        EEGwindow = reshape(EEG_approach2b(:,[g-4:g+5],:),128,10*N_trials);
        [Azloo2b_mse(:,gg,i),Azsig2b_mse(:,gg,i),Y2b_mse(:,gg,i),a2b_mse(:,gg,i),v2b_mse(:,gg,i),D2b_mse(:,i)] = single_trial_analysis(EEGwindow,ModalitySwitchEffect_Labels-1,10,0,[1 1000 0.05],[],0,1)
        g
    end
end

%toc

save LDA_Approach2b_Results.mat Azloo2b_sf Azloo2b_con Azloo2b_mse Azsig2b_sf Azsig2b_con Azsig2b_mse Y2b_sf Y2b_con Y2b_mse a2b_sf a2b_con a2b_mse v2b_sf v2b_con v2b_mse D2b_sf D2b_con D2b_mse 
