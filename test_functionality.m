%%
% addpath for the interface files
addpath '/home/sirfuser/devel/Rocci-SIRFPROJECT/SIRFPROJECT'
addpath '/home/sirfuser/devel/install/matlab/'
% launch PET
set_up_PET([]);
% get path for PET examples
sirf_examples_path = sirf.Utilities.examples_data_path('PET');
%%
% declare null STIRImageData and test initialise()
stir_data_null = ala.STIRImageData();
stir_data_null.initialise(40,5,6,1,1,1);
disp(stir_data_null.get_geom_info_sptr().get_info());
%%
% create STIRImageData from PET examples
stir_data_1 = ala.STIRImageData([sirf_examples_path,'/test_image_PM_QP_6.hv']);
disp(stir_data_1.get_geom_info_sptr().get_info());
stir_data_test = sirf.STIR.ImageData([sirf_examples_path,'/test_image_PM_QP_6.hv']);

%%
% create PETAcquisitionData from PET examples
acq_data = ala.PETAcquisitionDataInFile([sirf_examples_path,'/Utahscat600k_ca_seg4.hs']);
acq_data_test = sirf.STIR.AcquisitionData([sirf_examples_path,'/Utahscat600k_ca_seg4.hs']);

%%
% use as_array() to convert STIRImageData into an array
im = ala.STIRImageData([sirf_examples_path,'/brain/emission.hv']);
im_array = im.as_array();
im_array_one_pic = im_array(5,:,:);
%im_array_one_pic = reshape(im_array_one_pic,211,211);
%imshow(im_array_one_pic)
%% construct a "template" for the acquisition data
sino_template = ala.PETAcquisitionDataInMemory('PRT-1',1,1);


% construct an acquisition model and use it to simulate the data
acq_model = ala.PETAcquisitionModelUsingRayTracingMatrix();
acq_model.set_up(sino_template, im);
simulated_data = acq_model.forward(im);

%% reconstruct with FBP2D
recon = ala.FBP2DReconstructor();
recon.set_input(simulated_data);
recon.set_up(im);
recon.process();

%% get the output image of reconstructor
image_data = recon.get_output();
image_data.write('recon_test_image.hv');

%% test the SWIG-wrapped interfaces by comparing the result with manually wrapped functions
fprintf('the result of stir_data_1.dot(stir_data_1) is %g.\n', stir_data_1.dot(stir_data_1))
fprintf('the result of stir_data_test.dot(stir_data_test) is %g.\n', stir_data_test.dot(stir_data_test))
fprintf('the result of stir_data_1.norm() is %g.\n', stir_data_1.norm());
fprintf('the result of stir_data_test.norm() is %g.\n', stir_data_test.norm());
fprintf('the result of stir_data_1.is_complex() is %d (0 stands for false, 1 stands for true).\n', stir_data_1.is_complex());
%fprintf('the result of stir_data_test.is_complex() is %d (0 stands for false, 1 stands for true).\n', stir_data_test.is_complex());
fprintf('the result of acq_data.norm() is %g.\n', acq_data.norm());
fprintf('the result of acq_data_test.norm() is %g.\n', acq_data_test.norm());
fprintf('the reuslt of acq_data.is_complex() is %d (0 stands for false, 1 stands for true).\n', acq_data.is_complex());
%fprintf('the reuslt of acq_data_test.is_complex() is %d (0 stands for false, 1 stands for true).\n', acq_data_test.is_complex());

%% test as_array()
disp('the dimensions of stir_data_1 in each dimension is:');
disp(size(stir_data_1.as_array()));
disp('the dimensions of stir_data_test in each dimension is:');
disp(size(stir_data_test.as_array()));