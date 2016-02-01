package {
	
	/**
	 * ...
	 * @author Aris
	 */
	public class VectorCalculate {
          public var x:Number;
          public var y:Number;


                //賦予坐標值
          public function VectorCalculate(x:Number,y:Number) {
                        this.x = x;
                        this.y = y;
                }
                //轉為字符輸出
          public function toStr():String {
                        var rx = Math.round(this.x * 1000)/1000;
                        var ry = Math.round(this.y * 1000)/1000;
                        return ("[" + rx + ", " + ry + "]");
                }
                //重設坐標值
          public function reset(x:Number,y:Number) {
                        this.x = x;
                        this.y = y;
                }
                //克隆向量
          public function getClone() {
                        return new vector(this.x,this.y);
                }
                //比較向量
          public function equals(v):Boolean {
                        return (this.x == v.x && this.y == v.y);
                }
                //向量加法
          public function plus(v) {
                        this.x += v.x;
                        this.y += v.y;
                }
                //向量加法，返回值，不改變當前對象
          public function plusNew(v)​​ {
                        return new vector(this.x + v.x,this.y + v.y);
                }
                //向量減法
          public function minus(v) {
                        this.x -= v.x;
                        this.y -= v.y;
                }
                //向量減法，返回值，不改變當前對象
          public function minusNew(v)​​ {
                        return new vector(this.x - v.x,this.y - v.y);
                }
                //向量求逆
          public function negate() {
                        this.x = -this.x;
                        this.y = -this.y;
                }
                //向量求逆，返回值，不改變當前對象
          public function negateNew(v)​​ {
                        return new vector(- this.x,- this.y);
                }
                //向量縮放
          public function scale(s) {
                        this.x *= s;
                        this.y *= s;
                }
                //向量求逆，返回值，不改變當前對象
          public function scaleNew(s) {
                        return new vector(this.x * s,this.y * s);
                }
                //向量長度,經典的勾股定理
          public function getLength() {
                        return Math.sqrt(this.x * this.x + this.y * this.y);
                }
                //給定長度，修改vector對象的大小
          public function setLength(len) {
                        var r = this.getLength();
                        if (r) {
                                this.scale(len / r );
                        } else {
                                this.x = len;
                        }
                }
                //向量角度
          public function getAngle() {
                        return atan2D(this.y,this.x);
                }
                //直接算角度的方法
          public function atan2D(y,x) {
                        var angle=Math.atan2(-y,x)*(180/Math.PI);
                        angle*=-1;
                        return chaToFlashAngle(angle);
                }
                //將笛卡爾坐標轉成FLASH坐標的方法
          public function chaToFlashAngle(angle) {
                        angle%=360;
                        if (angle<0) {
                                return angle + 360;
                        } else {
                                return angle;
                        }
                }
                //保持角度，改造長度
          public function setAngle(angle) {
                        var r = this.getLength();
                        this.x= r*cosD(angle);
                        this.y= r*sinD(angle);
                }
                //向量旋轉
          public function rotate(angle) {
                        var ca = cosD(angle);
                        var sa = sinD(angle);

                        with (this) {
                                var rx = x*ca - y*sa;
                                var ry = x*sa + y*ca;
                                x = rx;
                                y = ry;
                        }
                }
                //向量旋轉，返回值，不改變當前對象
          public function rotateNew(angle) {
                        var v = new vector(this.x,this.y);
                        v.rotate(angle);
                        return v;
                }
                //點積
          public function dot(v) {
                        return (this.x * v.x + this.y * v.y);
                }
                //法向量，剛體碰撞的基礎公式
          public function getNormal() {
                        return new vector(- this.y,this.x);
                }
                //垂直驗證
          public function isPerpTo(v) {
                        return (this.dot(v) == 0);
                }
                //向量的夾角
          public function angleBetween(v) {
                        var dp =this.dot(v);
                        var cosAngle = dp / (this.getLength() * v.getLength());
                        return acosD(cosAngle);
                }
                //改造SIN方法
          public function sinD(angle) {
                        return Math.sin(angle * Math.PI / 180);
                }
                //改造COS方法
          public function cosD(angle) {
                        return Math.cos(angle * Math.PI / 180);
                }
                //改造反餘弦acos方法
          public function acosD(angle) {
                        return Math.acos(angle) * 180 / Math.PI;
                }
        }
}