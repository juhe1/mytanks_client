package alternativa.engine3d.objects
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.Material;
   
   use namespace alternativa3d;
   
   public class AnimSprite extends Sprite3D
   {
       
      
      private var _materials:Vector.<Material>;
      
      private var _frame:int = 0;
      
      private var _loop:Boolean = false;
      
      public function AnimSprite(width:Number, height:Number, materials:Vector.<Material> = null, loop:Boolean = false, frame:int = 0)
      {
         super(width,height);
         this._materials = materials;
         this._loop = loop;
         this.frame = frame;
         this.softAttenuation = 140;
      }
      
      public function get materials() : Vector.<Material>
      {
         return this._materials;
      }
      
      public function set materials(value:Vector.<Material>) : void
      {
         this._materials = value;
         if(value != null)
         {
            this.frame = this._frame;
         }
         else
         {
            material = null;
         }
      }
      
      public function get loop() : Boolean
      {
         return this._loop;
      }
      
      public function set loop(value:Boolean) : void
      {
         this._loop = value;
         this.frame = this._frame;
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      public function set frame(value:int) : void
      {
         var materialsLength:int = 0;
         var index:int = 0;
         var mod:int = 0;
         this._frame = value;
         if(this._materials != null)
         {
            materialsLength = this._materials.length;
            index = this._frame;
            if(this._frame < 0)
            {
               mod = this._frame % materialsLength;
               index = this._loop && mod != 0 ? int(mod + materialsLength) : int(0);
            }
            else if(this._frame > materialsLength - 1)
            {
               index = !!this._loop ? int(this._frame % materialsLength) : int(materialsLength - 1);
            }
            material = this._materials[index];
         }
      }
      
      override public function clone() : Object3D
      {
         var animSprite:AnimSprite = new AnimSprite(width,height,this._materials,this._loop,this._frame);
         animSprite.clonePropertiesFrom(this);
         animSprite.clipping = clipping;
         animSprite.sorting = sorting;
         animSprite.originX = originX;
         animSprite.originY = originY;
         animSprite.rotation = rotation;
         animSprite.perspectiveScale = perspectiveScale;
         return animSprite;
      }
   }
}
