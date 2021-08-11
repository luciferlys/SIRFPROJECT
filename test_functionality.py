import ala
c= ala.STIRImageData('D:/SIRF/SIRFbuild/INSTALL/share/SIRF-3.1/data/examples/PET/test_image_PM_QP_6.hv') 
b= ala.PETAcquisitionDataInFile('D:/SIRF/SIRFbuild/INSTALL/share/SIRF-3.1/data/examples/PET/Utahscat600k_ca_seg4.hs')
#c.fill(0)
print(c.dot(c))
print(b.dot(b))