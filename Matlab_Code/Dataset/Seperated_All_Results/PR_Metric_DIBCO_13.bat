cd C:\Users\Tanmoy\Desktop\Seperated_Final_Result\DIBCO_13\GT\
 for /R %%f in (*.bmp) do (
	"C:\Users\Tanmoy\Desktop\Seperated_Final_Result\BinEvalWeights\BinEvalWeights.exe" "%%f" 
 	)
@pause