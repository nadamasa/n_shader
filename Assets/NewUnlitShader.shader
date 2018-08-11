
Shader "Unlit/NewUnlitShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags {
            		"Queue"="Transparent"
            		"RenderType"="Transparent"
		}

		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            		#pragma geometry geom

			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			float rand(float3 co)
			{
				return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 56.787))) * 43758.5453);
			}

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
				
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = v.vertex;
				float2 uv;
				uv = o.uv;

				float r5  = rand(v.vertex + 4) * 3.14159 * 2;
				float r0 = rand(v.vertex + 0) * 3.14159 * 2 + _Time.y / r5;
				float r1 = rand(v.vertex + 1) * 3.14159 * 2 + _Time.y;
				float r2 = rand(v.vertex + 2) * 3.14159 * 2 + _Time.y;
				float r3 = rand(v.vertex + 3) * 3.14159 * 2 + _Time.y;

				o.vertex.x = cos(r0) /2 * (1 + sin(r2) / 5);
				o.vertex.z = sin(r0) /2 * (1 + sin(r2) / 5);
				o.vertex.y = sin(r1)/ 5;

				//o.vertex.xz += (rand(v.vertex) - 0.5) /10 ;
				//o.vertex.z += rand(v.vertex) ;

				o.vertex.x *= 1 - pow(sin(r1)/2.5, 2);
				o.vertex.z *= 1 - pow(sin(r1)/2.5, 2);

				o.color = float4(cos(float3(-1, 1, 0) * 3.14 * 2 / 3 + r5) / 2 + 0.5, 0);

				return o;
			}
			
			
			[maxvertexcount(3)]

			void geom(point appdata p[1], inout TriangleStream<v2f> stream){
				v2f o;

				o.color = p[0].color;
				float4 vp = mul(UNITY_MATRIX_MV, p[0].vertex);

				float sz = 0.002 * 5;
				
				o.uv = float2(   0,    1);
				o.vertex = mul(UNITY_MATRIX_P, vp + float4(o.uv * sz, 0, 0));
				stream.Append(o);
				o.uv = float2( 0.9, -0.5);
				o.vertex = mul(UNITY_MATRIX_P, vp + float4(o.uv * sz, 0, 0));
				stream.Append(o);
				o.uv = float2(-0.9, -0.5);
				o.vertex = mul(UNITY_MATRIX_P, vp + float4(o.uv * sz, 0, 0));
				stream.Append(o);
				stream.RestartStrip();
			}


			fixed4 frag (v2f i) : SV_Target
			{
				clip(0.5 - length(i.uv));
				return float4(i.color.xyz, smoothstep(0.5, 0.1, length(i.uv)));
				return smoothstep(0.5, 0.4, length(i.uv));
			}

			ENDCG
		}
/*
CGPROGRAM
#pragma surface surf Lambert

sampler2D _MainTex;

struct Input 
{
    float4 color : COLOR;
};

void surf(Input IN, inout SurfaceOutput o)
{
    o = IN;
}
ENDCG
*/
	}
}
