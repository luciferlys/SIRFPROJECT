# import project module ala
import ala
import sirf.STIR as PET
from matplotlib import pyplot as plt
import numpy
from os.path import join
# read PET data examples
sirf_examples = PET.examples_data_path('PET')

#%% data reading/creation
# test creating a STIRImageData object with given dimensions etc
stir_data= ala.STIRImageData()
stir_data.initialise((40,5,6),(1,1,1));
print(stir_data.get_geom_info_sptr().get_info())

path1 = join(sirf_examples,'test_image_PM_QP_6.hv')
stir_data= ala.STIRImageData(path1) 
stir_data_test= PET.ImageData(path1) 
print(stir_data.get_geom_info_sptr().get_info())

path2 = join(sirf_examples,'Utahscat600k_ca_seg4.hs')
Acq_data= ala.PETAcquisitionDataInFile(path2)
Acq_data_test= PET.AcquisitionData(path2)
#%% perform a simulation of a PET acquisition
#im=ala.STIRImageData(path1) 

# save figure
path3 = join(sirf_examples,'brain','emission.hv')
im= ala.STIRImageData(path3)
plt.imshow(im.as_array()[5,:,:])
filename = 'simu_graph.png'
plt.savefig(filename)
plt.close()

# construct a "template" for the acquisition data
sino_template= ala.PETAcquisitionDataInMemory("PRT-1",1,1)
#print(sino_template.get_info())

# construct an acquisition model and use it to simulate the data
acq_model = ala.PETAcquisitionModelUsingRayTracingMatrix();
acq_model.set_up(sino_template, im)
simulated_data = acq_model.forward(im)
#%% reconstruct with FBP2D
recon = ala.FBP2DReconstructor()
recon.set_input(simulated_data)
recon.set_up(im)
recon.process()   
image = recon.get_output()
# save figure
plt.imshow(image.as_array()[5,:,:])
filename = 'recon_graph.png'
plt.savefig(filename)
plt.close()

#%% plot some profiles
plt.figure()
plt.plot(im.as_array()[5,75,:])
plt.plot(image.as_array()[5,75,:])
plt.legend(["input", "reconstruction"])
plt.grid(True)
filename = 'profile_graph.png'
plt.savefig(filename)
plt.close()
#%%% more validation
# test ImageData wrapping
#stir_data.fill(0)
print(stir_data.dot(stir_data))
print(stir_data_test.dot(stir_data_test))
print(stir_data.norm())
print(stir_data_test.norm())
print(stir_data.is_complex())
print(stir_data_test.is_complex())
# test AcquisitionData wrapping
print(Acq_data.norm())
print(Acq_data_test.norm())
print(Acq_data.is_complex())
print(Acq_data_test.is_complex())
# test as_array
print(stir_data.as_array().shape)
print(stir_data_test.as_array().shape)
print(stir_data_test.as_array()[5,23,:])
plt.imshow(stir_data.as_array()[5,:,:])
plt.grid(True)
filename = 'test_graph1.png'
plt.savefig(filename)
plt.close()
plt.imshow(stir_data_test.as_array()[5,:,:])
plt.grid(True)
filename = 'test_graph2.png'
plt.savefig(filename)
plt.close()
# test from_array
stir_data.from_array(stir_data.as_array()*0)
print(stir_data.dot(stir_data))
print(stir_data.from_array(1))








