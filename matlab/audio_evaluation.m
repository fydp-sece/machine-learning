% Given a model, evaluate the performance.
baseDir = '../../';
addpath([baseDir, filesep, 'codes']);
addpath([baseDir, filesep, 'tools', filesep,'bss_eval']);
addpath([baseDir, filesep, 'tools', filesep,'bss_eval_3']);
addpath([baseDir, filesep, 'tools', filesep,'labrosa']);
addpath(['Data_with_dev']);

ModelPath=['/Users/peterchu/dev/fydp/prototypes/samples/deeplearningsourceseparation/codes/timit/demo'];

global SDR;

SDR.deviter=0;   SDR.devmax=0;   SDR.testmax=0;
SDR.devsar=0; SDR.devsir=0; SDR.testsar=0; SDR.testsir=0;

j=70;

% Load model
load([ModelPath, filesep, 'timit_model_', num2str(j),'.mat']);
eI.writewav=1;
eI.bss3=1;
eI.DataPath=[baseDir, filesep, 'codes', filesep, 'timit', ...
    filesep, 'Wavfile', filesep];
eI.saveDir = [baseDir, filesep, 'codes', filesep, 'timit', ...
    filesep, 'model_demo', filesep, 'results', filesep];

s1 = '/Users/peterchu/fydp_outputs/nmf/timit_denoising_groundtruth_speech.wav';
s2 = '/Users/peterchu/fydp_outputs/nmf/timit_denoising_groundtruth_noise.wav';
wavout_signal = '/Users/peterchu/fydp_outputs/nmf/timit_denoising_mixture_DENOISED.wav';

% posenhuang data
wavout_signal = '/Users/peterchu/fydp_outputs/nmf/timit_denoising_separated_speech.wav';

wavout_noise= '/Users/peterchu/fydp_outputs/nmf/timit_denoising_separated_noise.wav';

% posenhuang data
wavout_noise = '/Users/peterchu/fydp_outputs/nmf/timit_denoising_separated_noise.wav'

mixture = '/Users/peterchu/fydp_outputs/nmf/timit_denoising_mixture.wav';
 %  BSS_EVAL ( wav_truth_signal, wav_truth_noise, wav_pred_signal, wav_pred_noise, wav_mix )
Parms =  BSS_EVAL ( s1, s2, wavout_signal, wavout_noise, mixture );
fprintf('%s %s ioffset:%d iter:%d - no mask - \tSDR:%.3f\tSIR:%.3f\tSAR:%.3f\tNSDR:%.3f\n', 'model1', 1, 0, 2, Parms.SDR, Parms.SIR, Parms.SAR, Parms.NSDR);
