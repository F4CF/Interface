package mx.utils
{
	import flash.utils.ByteArray;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	[ResourceBundle("utils")]
	public class Base64Decoder
	{
		
		private static const ESCAPE_CHAR_CODE:Number = 61;
		
		private static const inverse:Array = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,62,64,64,64,63,52,53,54,55,56,57,58,59,60,61,64,64,64,64,64,64,64,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,64,64,64,64,64,64,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64];
		 
		
		private var count:int = 0;
		
		private var data:ByteArray;
		
		private var filled:int = 0;
		
		private var work:Array;
		
		private var resourceManager:IResourceManager;
		
		public function Base64Decoder()
		{
			this.work = [0,0,0,0];
			this.resourceManager = ResourceManager.getInstance();
			super();
			this.data = new ByteArray();
		}
		
		public function decode(encoded:String) : void
		{
			var c:Number = NaN;
			for(var i:uint = 0; i < encoded.length; i++)
			{
				c = encoded.charCodeAt(i);
				if(c == ESCAPE_CHAR_CODE)
				{
					this.work[this.count++] = -1;
					addr80:
					if(this.count == 4)
					{
						this.count = 0;
						this.data.writeByte(this.work[0] << 2 | (this.work[1] & 255) >> 4);
						this.filled++;
						if(this.work[2] == -1)
						{
							break;
						}
						this.data.writeByte(this.work[1] << 4 | (this.work[2] & 255) >> 2);
						this.filled++;
						if(this.work[3] == -1)
						{
							break;
						}
						this.data.writeByte(this.work[2] << 6 | this.work[3]);
						this.filled++;
					}
				}
				else if(inverse[c] != 64)
				{
					this.work[this.count++] = inverse[c];
					§§goto(addr80);
				}
			}
		}
		
		public function drain() : ByteArray
		{
			var result:ByteArray = new ByteArray();
			var oldPosition:uint = this.data.position;
			this.data.position = 0;
			result.writeBytes(this.data,0,this.data.length);
			this.data.position = oldPosition;
			result.position = 0;
			this.filled = 0;
			return result;
		}
		
		public function flush() : ByteArray
		{
			var message:String = null;
			if(this.count > 0)
			{
				message = this.resourceManager.getString("utils","partialBlockDropped",[this.count]);
				throw new Error(message);
			}
			return this.drain();
		}
		
		public function reset() : void
		{
			this.data = new ByteArray();
			this.count = 0;
			this.filled = 0;
		}
		
		public function toByteArray() : ByteArray
		{
			var result:ByteArray = this.flush();
			this.reset();
			return result;
		}
	}
}
