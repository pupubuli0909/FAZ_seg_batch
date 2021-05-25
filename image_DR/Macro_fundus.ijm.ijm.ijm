run("Split Channels");
selectWindow("image001.png (green)");
selectWindow("image001.png (blue)");
close();
selectWindow("image001.png (red)");
close();
selectWindow("image001.png (green)");
run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
//run("Brightness/Contrast...");
setMinAndMax(-35, 206);
run("Close");
run("Duplicate...", "title=[image001.png (blur)-1]");
run("Gaussian Blur...", "sigma=5");
selectWindow("image001.png (green)");

run("Subtract Background...", "rolling=30 light");
imageCalculator("Subtract create", "image001.png (green)","image001.png (blur)-1");


selectWindow("image001.png (green)");
