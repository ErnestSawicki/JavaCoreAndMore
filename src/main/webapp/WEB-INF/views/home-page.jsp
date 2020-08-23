<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home Page</title>
</head>
<body>
<canvas id="gameCanvas" width="800" height="600"></canvas>

<script>
var canvas;
var canvasContext;

	//gameConditions
const WINNING_SCORE = 3;
var player1Score = 0;
var player2Score = 0;
var showingWinScreen = false;

	//ball constants and variables
var ballWidth = 20;
var ballHeight = 40;
var ballX=50;
var ballY=50;
var ballSpeedX =10;
var ballSpeedY = 10;

	//paddle constants and variables
const PADDLE_WIDTH = 20;
const PADDLE_HEIGHT = 150;
const PADDLE_1X = 20;
const PADDLE_2X = 800 - PADDLE_WIDTH -20;
var paddle1Y = 200;
var paddle2Y = 200;



var contact = new Boolean(false);

window.onload = function(){
	canvas = document.getElementById('gameCanvas');
	canvasContext = canvas.getContext('2d');
	
	var framesPerSecond = 30;
	setInterval(function(){
					moveEverything();
					drawEverything();
				}, 1000/framesPerSecond);
				
	canvas.addEventListener('mousemove', function(evt){
		var mousePos = calculateMousePos(evt);
		paddle1Y = mousePos.y - PADDLE_HEIGHT/2;
	});
	canvas.addEventListener('mousedown', handleMouseClick);
	}
	
	function handleMouseClick(evt){
		if(showingWinScreen) {
			player1Score = 0;
			player2Score = 0;
			showingWinScreen = false;
			}
	}
	
	function moveEverything(){
		if(showingWinScreen){
			return;
		}
		
		//movement condition X and Y
		ballX += ballSpeedX;
		ballY += ballSpeedY;
		
		//return conditions
			//condition for "goal"
			
			//playerToLeft
		if (ballX - ballWidth == 0){
			//Must be before ball reset
			player2Score++;
			resetBallPosition();
		}
			//playerToRight
		if (ballX + ballWidth == canvas.width){
			//Must be before ball reset
			player1Score++;
			resetBallPosition();
		}
			
			//condition for top/bottom bounce
		if (ballY + ballWidth > canvas.height || ballY - ballWidth < 0){
			ballSpeedY = -ballSpeedY;
		}
		
			//condition for paddle bounce
				//playerToLeft -> Player1
		if (ballY > paddle1Y && ballY < paddle1Y + PADDLE_HEIGHT && ballX - ballWidth == PADDLE_1X + PADDLE_WIDTH){
				ballSpeedX = -ballSpeedX;
				var deltaY = ballY - (paddle1Y + PADDLE_HEIGHT/2);
				ballSpeedY = deltaY * 0.25;
		}
				//playerToRight -> Player2
		if (ballY > paddle2Y && ballY < paddle2Y + PADDLE_HEIGHT && ballX == PADDLE_2X - PADDLE_WIDTH){
				ballSpeedX = -ballSpeedX;
				var deltaY = ballY - (paddle2Y + PADDLE_HEIGHT/2);
				ballSpeedY = deltaY * 0.25;
		}
		
		//playerAI
		player2AI();
		
		//console.log('ballY', ballY);
		//console.log('ballX', ballX);
		//console.log('paddleY', paddle1Y);
		//console.log('paddleY + PADDLE_HEIGHT', paddle1Y + PADDLE_HEIGHT);
		//console.log('paddleX vs ballX', PADDLE_X, ballX);
		}
	
	function drawEverything(){

		if(showingWinScreen){
				colorRect('black', 0, 0, canvas.width, canvas.height);
				canvasContext.fillStyle = 'white';
				canvasContext.fillText("click to continue", 350, 400);
				if (player1Score >= WINNING_SCORE){
					canvasContext.fillText("Player 1 won", 350, 500);
				} else {
					canvasContext.fillText("Player 2 won", 350, 500);
				}
			return;
		}
		// mainCanvas
		colorRect('black', 0, 0, canvas.width, canvas.height);
		//paddleOfPlayer1
		colorRect('white', PADDLE_1X, paddle1Y, PADDLE_WIDTH, PADDLE_HEIGHT);
		//paddleOfPlayer2
		colorRect('white', PADDLE_2X, paddle2Y, PADDLE_WIDTH, PADDLE_HEIGHT);
		//ball
		colorBall('red', ballX, ballY, ballWidth);
		//net
		drawNet();
		//score
		canvasContext.fillStyle = 'white';
		canvasContext.fillText("Player 1", canvas.width /4, 150);
		canvasContext.fillText(player1Score, canvas.width /4 + 50, 150);
		canvasContext.fillText("Player 2", canvas.width*3/4, 150);
		canvasContext.fillText(player2Score, canvas.width*3/4 + 50, 150);
		
	}
	
	function drawNet(){
		for (var i = 0; i < canvas.height; i+=40){
			colorRect('white', canvas.width/2 -1, i + 5, 2, 20);
		}
	}
	
	function colorRect(color, positionX, positionY, width, height){
			canvasContext.fillStyle = color;
			canvasContext.fillRect(positionX,positionY,width,height);	
	}
	
	function colorBall(color, positionX, positionY, radius){
			canvasContext.fillStyle = color;
			canvasContext.beginPath();
			canvasContext.arc(positionX, positionY, radius, 0, Math.PI*2, true);
			canvasContext.fill();
	}
	
	function calculateMousePos(evt){

		var rect = canvas.getBoundingClientRect();
		var root = document.documentElement;
		var mouseX = evt.clientX - rect.left - rect.scrollLeft;
		var mouseY = evt.clientY - rect.top - root.scrollTop;
		return {
			x:mouseX,
			y:mouseY
		}
	}

	function resetBallPosition(){
		if (player1Score == WINNING_SCORE || player2Score == WINNING_SCORE){
			showingWinScreen = true;
		}
	
		ballX = canvas.width /2;
		ballY = canvas.height/2;
		ballSpeedX = -ballSpeedX;
		ballSpeedY = 10;
		
	}

	function player2AI(){
		var paddleSpeed = 7;
		var paddle2YMiddle = paddle2Y + PADDLE_HEIGHT/2;
		if (paddle2YMiddle < ballY){
			paddle2Y += paddleSpeed;
		} else {
			paddle2Y -= paddleSpeed;
		}
	}

</script>
</body>
</html>

