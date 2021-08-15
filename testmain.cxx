#include "test.h"
#include <iostream>
#include "sirf/common/DataContainer.h"
#include "sirf/STIR/stir_data_containers.h"
#include "sirf/STIR/stir_x.h"

int main()
{
	sirf::STIRImageData a;
	//sirf::PETAcquisitionData b;
	sirf::PETAcquisitionDataInFile c;
	sirf::PETAcquisitionDataInMemory d;
	sirf::xSTIR_FBP2DReconstruction e;
	sirf::PETAcquisitionModel f;
	sirf::PETAcquisitionSensitivityModel g;
	sirf::PETAcquisitionModelUsingMatrix h;

	return 0;
}
