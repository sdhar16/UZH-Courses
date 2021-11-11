workingDir = "data";
imageNames = dir(fullfile("data",'outputs_bilinear','*.jpg'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile(workingDir,'shuttle_out_bilinear.avi'));
outputVideo.FrameRate = 30;
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,'outputs_bilinear',imageNames{ii}));
   writeVideo(outputVideo,img)
end

close(outputVideo)
