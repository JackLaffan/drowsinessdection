% Detects eyes using the Viola Jones algorithm, eyes are cropped and a Canny
% Edge Detector is applied to find the edge intensities. The holes are
% filled and the Hough Transform is applied to find the pupils. The eyes
% are tracked in a live video stream using the KLT algorithm.

% Create objects for detecting eyes, tracking points, acquiring and
% displaying video frames.

% Create the eye detector object.
eyeDetector = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',16);

% Create the point tracker object.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Create the webcam object.
cam = webcam();

% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);

% Create the video player object. 
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

% Capture and process video frames from the webcam in a loop to detect and
% track a face. The loop will run for 3600 frames (2 mins) or until the video 
% player window is closed.

runLoop = true;
numPts = 0;
frameCount = 0;

while runLoop && frameCount < 10000
    
    % Get the next frame.
    videoFrame = snapshot(cam);
    videoFrameGray = rgb2gray(videoFrame);
    frameCount = frameCount + 1;
    
    if numPts < 10
        
        % Detection mode.
        bbox = eyeDetector.step(videoFrameGray);
      
        % If the eyes are detected then perform the Hough Transform
        if ~isempty(bbox)
            
            % Follows the same method as the still images
            Eyes = imcrop(videoFrame, bbox);
            EyesGray = rgb2gray(Eyes);
            edgeDetect = edge(EyesGray,'Canny');
            circFill = imfill(edgeDetect,'holes');
            [centers, radii] = imfindcircles(circFill, [1, 4]);
            figure; imshow(circFill); title('Cropped Eyes');
            viscircles(centers, radii);         
            
            % Find corner points inside the detected region.
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));
                  
            % Convert the rectangle represented as [x, y, w, h] into an
            % M-by-2 matrix of [x,y] coordinates of the four corners. This
            % is needed to be able to transform the bounding box to display
            % the orientation of the face.
            bboxPoints = bbox2points(bbox(1, :));  
            
            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4] 
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);
            
            % Display a bounding box around the detected eyes.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3, 'Color', 'r');
          
        end
           
    else
        % Tracking mode.
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);
                
        numPts = size(visiblePoints, 1);       
        
        if numPts >= 10
            
            % Estimate the geometric transformation between the old points
            % and the new points.
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);            
            
            % Apply the transformation to the bounding box.
            bboxPoints = transformPointsForward(xform, bboxPoints);
            
            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4] 
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);            
            
            % Display a bounding box around the eyes being tracked.
            videoFrame = insertShape(videoFrameGray, 'Polygon', bboxPolygon, 'LineWidth', 3, 'Color', 'r');
                       
        end

    end
        
    % Display the annotated video frame using the video player object.
    step(videoPlayer, videoFrame);

    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
    
end

% Clean up.
clear cam;
release(videoPlayer);
release(eyeDetector);