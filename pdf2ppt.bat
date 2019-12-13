@echo off

set PDF=%1
echo Processing %PDF%
set Folder=%~n1
set BaseFolder=%~d1%~p1
set full_folder="%BaseFolder%%Folder%"
mkdir %full_folder%
echo 	Splitting PDF file to pages...
pdftk "%PDF%" burst output "%full_folder%\%%04d.pdf"
pdftk "%PDF%" dump_data output "%full_folder%\metadata.txt"
echo 	Converting pages to JPEG files... 
for %%f in (%full_folder%\*.pdf) do (
	magick -colorspace RGB -interlace none -quality 75 %%f %%~dpnf.jpg
)
echo 	Converting JPEG files to PPTX...
python jpg2ppt.py --output_path="%full_folder%.pptx"  --images_regex="%full_folder%\*.jpg"
echo All done
