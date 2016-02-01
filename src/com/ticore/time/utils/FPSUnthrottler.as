package com.ticore.time.utils {
 import flash.display.Shape;
 import flash.events.Event;
 import flash.events.SampleDataEvent;
 import flash.media.Sound;
 import flash.media.SoundChannel;
 import flash.utils.getTimer;
 import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
 import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
 import Spark.Utils.GlobalEvent.EventExpress;
 import strLib.proxyStr.ProxyPVEStrList;
 
 /**
  * 利用 Sound SampleData 事件
  * 迫使 Flash Player 背景執行時，仍以指定 FPS 運作
  * 
  * 使用方式
  * 
  * 1. 建立 FPSUnthrottler 實體，直接呼叫 activate 啟動
  * 
  * 或是
  * 
  * 2. 將 FPSUnthrottler 實體加入到 DisplayList
  *   它會自動偵測目標 FPS 與實際 FPS，決定啟動或是停止
  * 
  * @author Ticore Shih
  */
 public class FPSUnthrottler extends Shape {
  
	 
  private var _oldTimer:int; 
  private var _fps:int;
  private var _flag:Boolean;
   //private var _showFPS:String;
  private var _oldFps:int; 
  //protected var snd:Sound = new Sound();
  //protected var sndCh:SoundChannel;
  public function FPSUnthrottler() {
   //this.snd.addEventListener(SampleDataEvent.SAMPLE_DATA,onSameplDataHandler, false, 0, true);
   
   addEventListener(Event.ADDED_TO_STAGE, onAddStageHandler, false, 0, true);
   addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStageHandler, false, 0, true);
  }
  

  
  
  protected function onAddStageHandler(e:Event):void{
     this._oldTimer = getTimer();
	 this._flag = true;
	 this._oldFps = stage.frameRate;
	 addEventListener(Event.ENTER_FRAME, onEnterFrameHandler, false, 0, true);
  }
  
  protected function onRemoveStageHandler(e:Event):void{
   removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler, false);
  }
  
  
  protected var recentFrameTimes:Array = [];
  
  protected function onEnterFrameHandler(e:Event):void{
   
   this._fps++;
   var throttleFrameTime:int = 100;
   var targetFrameTime:int = 1000 / stage.frameRate;
   
   // 原本設定的 FPS 就已經低於 Throttle FPS 了
   if (targetFrameTime > throttleFrameTime - 20) {
    //deactivate();
    return;
   }
   
   var currTime:int = getTimer();
   var lastFrameTime:int = currTime - recentFrameTimes[0];
   
   if (currTime-1000>this._oldTimer) {
      trace("FPS>>" + this._fps + " / " + stage.frameRate);
	  this._oldTimer = getTimer();
	  this._fps = 0;
   }
   
   
   recentFrameTimes.unshift(currTime);
   var maxSampleLen:int = 300;
   var sampleLen:int = recentFrameTimes.length = Math.min(recentFrameTimes.length, maxSampleLen);
   var avgFrameTimeTotal:int = (recentFrameTimes[0] - recentFrameTimes[sampleLen - 1]) / sampleLen;
   
 
   if (lastFrameTime > throttleFrameTime) {
    // 最後一次影格事件突然小於 2 FPS
    //activate();
   } else if (avgFrameTimeTotal <= targetFrameTime) {
    // 連續平均影格事件 FPS 小於等於目標 FPS
    //deactivate();
   }
  }
  
  
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  
  
  /*
  protected function onSameplDataHandler(e:SampleDataEvent):void{
      e.data.position = e.data.length = 4096 * 4;
  }
  */
  
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  
  public function activate():void{
   //if (this.sndCh) return;
   trace("__TimerFrezze>>" + ServerTimework.GetInstance().ServerTime);
   trace("Freeze<FPS>>>"+this._fps+" / "+stage.frameRate);
  
   if ( this._flag==true && this._fps<=10) {
   
	   trace("__TimerFrezze>>" + ServerTimework.GetInstance().ServerTime);
	   trace("Freeze<FPS>>>"+this._fps+" / "+stage.frameRate);
	   this._oldFps = this._fps;
	   this._flag = false;   
   }
   //this.sndCh = this.snd.play();
  }
  
  
  public function deactivate():void{
   //if (!sndCh) return;
    trace("_ResetStar>>" + ServerTimework.GetInstance().ServerTime);
	trace("_ResetStar<FPS>>>"+this._fps+" / "+stage.frameRate);
   if (this._flag == false && this._fps>=(stage.frameRate-5) && this._oldFps<=10) {
	   trace("_ResetStar>>" + ServerTimework.GetInstance().ServerTime);
	   trace("_ResetStar<FPS>>>"+this._fps+" / "+stage.frameRate);
	   this._flag = true;
	   this._oldFps = this._fps;
	   EventExpress.DispatchGlobalEvent(ProxyPVEStrList.FPSEvent_Reset);
	   if(TimeLineObject.GetTimeLineObject()!=null)TimeLineObject.GetTimeLineObject().ResetAllTime();
	 }
   
   
   //sndCh.stop();
   //sndCh = null;
  }
  
  
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 }
}