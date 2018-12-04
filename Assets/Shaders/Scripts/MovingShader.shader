Shader "Custom/MovingShader"
{
	Properties
	{
	// appears in the inspectes like public c# variables
		// If user wants a backround image for effect (Optional use)
 	// Scrolls texture to the right
		_ScrollTexture("ScrollTexture" , 2D) = "white" {}
		_ScrollSpeedU("ScrollSpeedU", Range(-5.0,5.0)) = 1
		_ScrollSpeedV("ScrollSpeedV", Range(-5.0,5.0)) = 1
	
	// Scrolls Texture to the left
		_ScrollTexture1("ScrollTexture1" , 2D) = "white" {}
		_ScrollSpeedU1("ScrollSpeedsU1", Range(-5.0,5.0)) = 1
		_ScrollSpeedV1("ScrollSpeedV1", Range(-5.0,5.0)) = 1

		_Tint("TintColour" , Color) = (1,1,1,1)
		_Colour("Colour" , Color) = (0,0,0,0)
		//	_Transparency("Transparency ", Range(0.0, 1)) = 0.6
	}
	SubShader
	{
		// No culling or depth

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 MainUV : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float2 ScrollUv : TEXCOORD1;
				float2 ScrollUv1 : TEXCOORD2;

			};
			//bridges the above property into cg.
			// A sampler contains our texture
 			sampler2D _ScrollTexture;
			sampler2D _ScrollTexture1;

 			float4 _ScrollTexture_ST;
			float _ScrollSpeedU;
			float _ScrollSpeedV;
			
			float4 _ScrollTexture1_ST;
			float _ScrollSpeedU1;
			float _ScrollSpeedV1;
			float4 _Colour;
			//float _Transparency;
			float4 _Tint;
			// has the texture tiling and offsets
			v2f vert(appdata v)
			{
				// stores uv in a variable so it can be changed;
				float2 ScrollUv = v.uv;
				float2 ScrollUv1 = v.uv;

				// Moves the textures XPOS
				ScrollUv.x += _Time.y * _ScrollSpeedU;
				// Moves the textures YPOS
				ScrollUv.y += _Time.y * _ScrollSpeedV;
				
				// Moves the textures XPOS
				ScrollUv1.x += _Time.y * _ScrollSpeedU1;
				// Moves the textures YPOS
				ScrollUv1.y += _Time.y * _ScrollSpeedV1;
				v2f o;
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				// Scales the uv Tiles with the _MainTex
 				o.ScrollUv = TRANSFORM_TEX(ScrollUv, _ScrollTexture);
				o.ScrollUv1 = TRANSFORM_TEX(ScrollUv1, _ScrollTexture1);

				return o;
			}
			fixed4 frag(v2f i) : SV_Target
			{
				// Add Colour to the texture?
			fixed4 Colour = _Colour;

			// fixed4 MainColour = tex2D(_MainTex,i.MainUV);
			 fixed4 ScrollColour = tex2D(_ScrollTexture, i.ScrollUv) + _Tint;
			 fixed4 ScrollColour1 = tex2D(_ScrollTexture1, i.ScrollUv1) +_Tint;

			// MainColour.a = _Transparency;
			 // Reutrns the main texture with the moving texture
			return   ScrollColour + ScrollColour1 + Colour;
			}
			ENDCG
		}
	}
}
