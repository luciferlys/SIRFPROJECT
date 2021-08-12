import ala
SIRFpath='D:/SIRF/SIRFbuild/INSTALL/'
SIRFpath='/home/sirfuser/devel/install'
c= ala.STIRImageData(SIRFpath + '/share/SIRF-3.1/data/examples/PET/test_image_PM_QP_6.hv') 
b= ala.PETAcquisitionDataInFile(SIRFpath + '/share/SIRF-3.1/data/examples/PET/Utahscat600k_ca_seg4.hs')
#c.fill(0)
print(c.dot(c))
print(c.as_array().shape)
print(b.dot(b))
