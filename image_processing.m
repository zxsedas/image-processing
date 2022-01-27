function image
    clear
    h0=figure('position', [50 65 1200 600]);
    % original image 、 processing image 、 gray hist
    axes1 = axes(gcf, 'position', [-0.01 0.5 0.5 0.5], 'Visible', 'off');
    axes2 = axes(gcf, 'position', [0.5 0.5 0.5 0.5], 'Visible', 'off');
    axes3 = axes(gcf, 'position', [0.65 0.1 0.3 0.3], 'Visible', 'off');
    % original、current、gray Matrix
    orignalMatrix = [];
    currentMatrix = [];
    grayMatrix = [];
    % Open image btn
    but1con=uicontrol(gcf, 'style', 'togglebutton',...
        'string', 'Open Image',...
        'value',0,...
        'position', [20 100 80 60],...
        'callback',@openImage);
    % Recover image btn
    but2con=uicontrol(gcf, 'style', 'togglebutton',...
        'string', 'Recovery',...
        'value',0,...
        'position', [20 20 80 60],...
        'callback',@recoveryImage);
    % processing btn
    but3con=uicontrol(gcf, 'style', 'togglebutton',...
        'string', 'processing',...
        'value',0,...
        'position', [290 20 100 60],...
        'callback',@processingImage);
    % average filter btn
    but7con=uicontrol(gcf, 'style', 'togglebutton',...
        'string', 'average filter',...
        'value',0,...
        'position', [420 20 80 60],...
        'callback', @avgFilter);
    % input num*num filter
    Edit1=uicontrol('parent', h0,...
        'units', 'points',...
        'tag', 'Edit1',...
        'style', 'edit',...
        'fontsize', 12,...
        'string', '[3,3]',...
        'HorizontalAlignment','center',...
        'Position',[315 70 60 20]);
    % processing img fun List
    List1=uicontrol('parent', h0,...
        'style', 'listbox',...
        'position', [120 20 150 140],...
        'FontSize', 11,...
        'string', 'Binary|Graying|Gray Equal|Edge Sharpening|Laplacian|Laplacian Log|edge Preserving Bluring|Salt Pepper Noise|gaussian Noise|median Filter',...
        'value', 1);
    % processing image
    function processingImage(src, event)
        if List1.Value == 1
           binaryImage(src, event);
        elseif List1.Value == 2
            grayingImage(src, event);
        elseif List1.Value == 3
            histEqual(src, event);
        elseif List1.Value == 4
           edgeSharpening(src, event);
        elseif List1.Value == 5
            laplacian(src, event);
        elseif List1.Value == 6
            laplacianLog(src, event);
        elseif List1.Value == 7
            edgePreservingBluring(src, event);
        elseif List1.Value == 8
            SaltPepperNoise(src, event);
        elseif List1.Value == 9
            gaussianNoise(src, event);
        elseif List1.Value == 10    
            medianFilter(src, event);
        end
    end
    % open image on host
    function openImage(src,event)
        % start folder path
        startingFolder = pwd;
        selectImagePath = '';
        defaultFileName = fullfile('startingFolde', '*.*'); % or *.png - whatever extension you want.
        % get file path
        [baseFileName, folder] = uigetfile(defaultFileName);
        if isequal(baseFileName, 0)
            disp('User selected Cancel');
        else
            selectImagePath = fullfile(folder, baseFileName);
        end
        % draw SelectImage on axes1 and setting orignal matrix
        axes(axes1);
        i = imread(selectImagePath);
        imshow(i);
        orignalMatrix = getframe(axes1).cdata;
        currentMatrix = orignalMatrix;
        axes(axes2);
        imshow(i);
    end
    % recovery axes2 and gray hist
    function recoveryImage(src, event)
        currentMatrix = orignalMatrix;
        axes(axes2);
        imshow(currentMatrix);
        
        grayMatrix = [];
        axes(axes3);
        set(histogram, 'Visible', 'off');

        display(get(List1, 'value'));
    end
    % plot binary image on axes2
    function binaryImage(src, event)
        currentMatrix = rgb2gray(currentMatrix);
        currentMatrix = imbinarize(currentMatrix);
        %meanIntensity = mean(grayMatrix(:));
        %imgbinary = grayMatrix > meanIntensity;
        axes(axes2);
        imshow(currentMatrix);
    end
    % plot gray image on axes2
    function grayingImage(src, event)
        grayMatrix = rgb2gray(currentMatrix);
        currentMatrix = grayMatrix;
        axes(axes2);
        imshow(grayMatrix);
        plotHistImage(src, event);
    end
    % plot gray hist on axes3
    function plotHistImage(src, event)
        % if grayMatrix is not empty, plot hist
        if isempty(grayMatrix)
            disp('yet graying');
        else
            axes(axes3);
            imhist(grayMatrix);
        end
    end
    % plot gray equal hist on axes3
    function histEqual(src, event)
        % if grayMatrix is not empty, plot hist
        if isempty(grayMatrix)
            disp('yet graying');
        else
            axes(axes3);
            grayMatrix = histeq(grayMatrix);
            imhist(grayMatrix);

            axes(axes2);
            imshow(grayMatrix);
        end
    end
    %average filter
    function avgFilter(src, event)
        filter = str2num(Edit1.String);
        f = fspecial('average', filter);
        currentMatrix = imfilter(currentMatrix, f);
        axes(axes2);
        imshow(currentMatrix);
    end
    % edge sharpening
    function edgeSharpening(src, event)
        u = fspecial('unsharp', 0.5);
        currentMatrix = imfilter(currentMatrix, u);
        axes(axes2);
        imshow(currentMatrix);
    end
    % laplacian
    function laplacian(src, event)
        l = fspecial('laplacian');
        currentMatrix = imfilter(currentMatrix, l, 'symmetric');
        axes(axes2);
        imshow(currentMatrix);
    end
    % laplacian Log
    function laplacianLog(src, event)
        l = fspecial('log');
        currentMatrix = imfilter(currentMatrix, l, 'symmetric');
        axes(axes2);
        imshow(currentMatrix);
    end
    % edge preserving blurring filter
    function edgePreservingBluring(src, event)
        currentMatrix = imbilatfilt(currentMatrix);
        axes(axes2);
        imshow(currentMatrix);
    end
    % salt and pepper noise
    function SaltPepperNoise(src, event)
        currentMatrix = imnoise(currentMatrix, 'salt & pepper');
        axes(axes2);
        imshow(currentMatrix);
    end
    % gaussian noise
    function gaussianNoise(src, event)
        currentMatrix = imnoise(currentMatrix, "gaussian");
        axes(axes2);
        imshow(currentMatrix);
    end
    % median filter
    function medianFilter(src, event)
        currentMatrix = medfilt2(currentMatrix, str2num(Edit1.String));
        axes(axes2);
        imshow(currentMatrix);
    end
end