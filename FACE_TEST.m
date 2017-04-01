%% Face Detection and Tracking Using Live Video Acquisition
% This example shows how to automatically detect and track a face in a live
% video stream, using the KLT algorithm.   

%% Setup
% Create objects for detecting faces, tracking points, acquiring and
% displaying video frames.

% Create the face detector object.
%faceDetector = vision.CascadeObjectDetector();
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

%% Detection and Tracking
% Capture and process video frames from the webcam in a loop to detect and
% track a face. The loop will run for 3600 frames or until the video player
% window is closed.

runLoop = true;
numPts = 0;
frameCount = 0;

while runLoop && frameCount < 3600
    
    % Get the next frame.
    videoFrame = snapshot(cam);
    videoFrameGray = rgb2gray(videoFrame);
    frameCount = frameCount + 1;
    
    if numPts < 10
        % Detection mode.
        bbox = eyeDetector.step(videoFrameGray);
      
        if ~isempty(bbox)
            
            Eyes = imcrop(videoFrame, bbox);
            %size(Eyes) %cropped image is 3D matrix; convert to BW 
            EyesGray = rgb2gray(Eyes);
            BW2 = edge(EyesGray,'Canny');
            BW1 = imfill(BW2,'holes');
            [centers, radii] = imfindcircles(BW1, [1, 4]);
            figure; imshow(BW1); title('Cropped Eyes');
            viscircles(centers, radii);
            %size(EyesGray) %cropped image is now grayscale; 2D matrix
            %eyesClosed(EyesGray)
            
            
            % Find corner points inside the detected region.
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));
       
            
            % Save a copy of the points.
            %oldPoints = xyPoints;
            
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