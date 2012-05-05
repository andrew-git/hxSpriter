package com.revolugame.hxSpriter;

import haxe.xml.Fast;
import flash.utils.ByteArray;

/**
 * ...
 * @author adrien
 */
class DataSpriterCharacter 
{
	var _name : String;
	
	var _animations : Hash<DataAnimation>;
	var _frames : Hash<DataFrame>;
	
	public var frame(getFrame, null): DataFrame;
	var _animation : DataAnimation;
	
	public var onChangeFrame:Void->Void;
	
	public function new (pData: String, pOnChangeFrame: Void->Void) 
	{
		var source : Fast = new Fast( Xml.parse( nme.Assets.getText(pData) ) );
		var node : Fast = null;
		
		source = source.node.spriterdata;
		
		_animations = new Hash();
		for (node in source.node.char.nodes.anim)
			_animations.set(node.node.name.innerData, new DataAnimation(node, pOnChangeFrame) );
	
		_frames = new Hash();
		for( node in source.nodes.frame)
			_frames.set( node.node.name.innerData, new DataFrame(node) );
	
		// animation name
		_name = source.node.char.node.name.innerData;
		
		onChangeFrame = pOnChangeFrame;
	}

	public function play(pName:String, ?pReset:Bool = false, ?pFrame:Int = 0):Void
	{
		if (_animation != null && _animation.name == pName)
		{
			if (pReset) _animation.reset(pFrame);
			return;
		}
			
		_animation = _animations.get(pName);
		_animation.reset(pFrame);
		
		onChangeFrame();
	}
		
	public function update(pElapsed:Float):Void
	{
		if (_animation != null) 
			_animation.update(pElapsed);
	}
		
	private function onAnimChangeFrame():Void
	{
		onChangeFrame();
	}
	
	/**
	 * Return the dataframe of the current animation
	 */
	private function getFrame():DataFrame
	{
		if (_animation != null)
			return _frames.get(_animation.frame.name);
		
		return null;
	}

}
