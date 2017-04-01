% Create a cascade detector object.
eyeDetector = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',16);

% Create a point tracker and enable the bidirectional error constraint to
% make it more robust in the presence of noise and clutter.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Read a video frame and run the face detector.
videoFileReader = vision.VideoFileReader('test_vid.avi');
videoFrame      = step(videoFileReader);

%Eyes = imcrop(videoFrame, bbox);
%figure; imshow(Eyes); title('Cropped Eyes');

%figure; imshow(videoFrame); title('Detected face');

% Initialize the tracker with the initial point locations and the initial
% video frame.
%points = points.Location;
%initialize(pointTracker, points, videoFrame);

%% Initialize a Video Player to Display the Results
% Create a video player object for displaying video frames.
videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(videoFrame, 2), size(videoFrame, 1)]+30]);

numPts = 0;

while ~isDone(videoFileReader)
    % get the next frame
    videoFrame = step(videoFileReader);
    
    if numPts < 2
        
        % Detection mode.
        %bbox = step(eyeDetector, videoFrame);
        bbox = eyeDetector.step(videoFrame);
            
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
                
                % Detect feature points in the face region.
                points = detectMinEigenFeatures(rgb2gray(videoFrame), 'ROI', bbox(1, :));
                
                % Make a copy of the points to be used for computing the geometric
                % transformation between the points in the previous and the current frames
                %oldPoints = points;
                
                % Convert the first box into a list of 4 points
                % This is needed to be able to visualize the rotation of the object.
                bboxPoints = bbox2points(bbox(1, :));
                
                % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4] 
                % format required by insertShape.
                bboxPolygon = reshape(bboxPoints', 1, []);
                
                %Draw the returned bounding box around the detected face.
                videoFrame = insertShape(videoFrame, 'Rectangle', bbox,'Color', 'r');
                
            end
            
            
    else
        %Track the points. Note that some points may be lost.
        [points, isFound] = step(pointTracker, videoFrame);
        visiblePoints = points(isFound, :);
        oldInliers = oldPoints(isFound, :);
    
        numPts = size(visiblePoints, 1);
    
        if numPts >= 2 % need at least 2 points
        
            % Estimate the geometric transformation between the old points
            % and the new points and eliminate outliers
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
        
            % Apply the transformation to the bounding box points
            bboxPoints = transformPointsForward(xform, bboxPoints);
                
            % Insert a bounding box around the object being tracked
            bboxPolygon = reshape(bboxPoints', 1, []);
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, ...
            'LineWidth', 2, 'Color', 'blue');
        end
    end
         
        % Reset the points
        %oldPoints = visiblePoints;
        %setPoints(pointTracker, oldPoints);        
    %end
    
    % Display the annotated video frame using the video player object
    step(videoPlayer, videoFrame);
end

% Clean up
release(videoFileReader);
release(videoPlayer);
release(pointTracker);

displayEndOfDemoMessage(mfilename)
