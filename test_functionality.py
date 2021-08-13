import ala
import sirf.STIR as PET
from matplotlib import pyplot as plt

SIRFpath='D:/SIRF/SIRFbuild/INSTALL/'
#SIRFpath='/home/sirfuser/devel/install'
c= ala.STIRImageData(SIRFpath + '/share/SIRF-3.1/data/examples/PET/test_image_PM_QP_6.hv') 
ctest= PET.ImageData(SIRFpath + '/share/SIRF-3.1/data/examples/PET/test_image_PM_QP_6.hv') 
im= ala.STIRImageData(SIRFpath + '/share/SIRF-3.1/data/examples/PET/test_image_PM_QP_6.hv') 
b= ala.PETAcquisitionDataInFile(SIRFpath + '/share/SIRF-3.1/data/examples/PET/Utahscat600k_ca_seg4.hs')
btest= PET.AcquisitionData(SIRFpath + '/share/SIRF-3.1/data/examples/PET/Utahscat600k_ca_seg4.hs')

#recon = ala.xSTIR_FBP2DReconstruction()
#recon.set_input(b)
#recon.set_up(im)
#recon.process()   
#image = recon.get_output()
#image.write('test.hv')

#c.fill(0)
print(ctest.dot(ctest))
print(c.dot(c))
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
plt.imshow(ctest.as_array()[5,:,:])



