function [fSegRefined] = applyClustering(f_ori)

fn = f_ori;

cluster=3; % the number of clustering centers
se=3; % the parameter of structuing element used for morphological reconstruction
w_size=3; % the size of fitlering window

[center1,U1,~,~] = FRFCM(double(fn),cluster,se,w_size);

f_seg = fcm_image(f_ori,U1,center1);
uniqueVals = unique(f_seg, 'sorted');
fSegRefined = f_seg;
for iRw = 1:1:size(fSegRefined,1)
    for jCol = 1:1:size(fSegRefined,2)
        if(fSegRefined(iRw,jCol) == uniqueVals(2))
            fSegRefined(iRw,jCol) = uniqueVals(3);  % putting it 255
        end
    end
end

end