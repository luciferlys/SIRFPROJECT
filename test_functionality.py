import ala
import sirf.STIR as PET
from matplotlib import pyplot as plt
import numpy

SIRFpath='D:/SIRF/SIRFbuild/INSTALL/'
SIRFpath='/home/sirfuser/devel/install'

#%% data reading/creation
# test creating a STIRImageData object with given dimensions etc
c= ala.STIRImageData()
c.initialise((40,5,6),(1,1,1));
print(c.get_geom_info_sptr().get_info())

c= ala.STIRImageData(SIRFpath + '/share/SIRF-3.1/data/examples/PET/test_image_PM_QP_6.hv') 
ctest= PET.ImageData(SIRFpath + '/share/SIRF-3.1/data/examples/PET/test_image_PM_QP_6.hv') 
print(c.get_geom_info_sptr().get_info())

b= ala.PETAcquisitionDataInFile(SIRFpath + '/share/SIRF-3.1/data/examples/PET/Utahscat600k_ca_seg4.hs')
btest= PET.AcquisitionData(SIRFpath + '/share/SIRF-3.1/data/examples/PET/Utahscat600k_ca_seg4.hs')

#%% perform a simulation of a PET acquisition
im= ala.STIRImageData(SIRFpath + '/share/SIRF-3.1/data/examples/PET/brain/emission.hv')
#im=ala.STIRImageData(SIRFpath + '/share/SIRF-3.1/data/examples/PET/test_image_PM_QP_6.hv') 
plt.imshow(im.as_array()[5,:,:])

# construct a "template" for the acquisition data
sino_template= ala.PETAcquisitionDataInMemory("PRT-1",1,1)
#print(sino_template.get_info())

# construct an acquisition model and use it to simulate the data
acq_model = ala.PETAcquisitionModelUsingRayTracingMatrix();
acq_model.set_up(sino_template, im)
simulated_data = acq_model.forward(im)
#%% reconstruct with FBP2D
recon = ala.xSTIR_FBP2DReconstruction()
recon.set_input(simulated_data)
recon.set_up(im)
recon.process()   
image = recon.get_output()
plt.imshow(image.as_array()[5,:,:])
#image.write('C:/Users/78309/Desktop/Testfiles/fbp.hv')

#%% plot some profiles
plt.figure()
plt.plot(im.as_array()[5,75,:])
plt.plot(image.as_array()[5,75,:])
plt.legend(["input", "reconstruction"])
#%%% more validation
#c.fill(0)
print(c.dot(c))
print(ctest.dot(ctest))

print(c.norm())
print(ctest.norm())

print(c.is_complex())
print(ctest.is_complex())

print(b.norm())
print(btest.norm())

print(b.is_complex())
print(btest.is_complex())

print(c.as_array().shape)
print(ctest.as_array().shape)

print(ctest.as_array())

plt.imshow(c.as_array()[5,:,:])
plt.grid(True)
filename = 'test_graph1.png'
folder = 'C:/Users/78309/Desktop/Pic/'
test_filepath = folder + filename
plt.savefig(test_filepath)
plt.close()

plt.imshow(ctest.as_array()[5,:,:])
plt.grid(True)
filename = 'test_graph2.png'
folder = 'C:/Users/78309/Desktop/Pic/'
test_filepath = folder + filename
plt.savefig(test_filepath)
plt.close()
    
plt.imshow(image.as_array()[5,:,:])
plt.grid(True)
filename = 'recon_graph.png'
folder = 'C:/Users/78309/Desktop/Pic/'
test_filepath = folder + filename
plt.savefig(test_filepath)
plt.close()

#plt.imshow(c.as_array()[5,:,:])
#plt.imshow(ctest.as_array()[5,:,:])
#plt.imshow(image.as_array()[5,:,:])


