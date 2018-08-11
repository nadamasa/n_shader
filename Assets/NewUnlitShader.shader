Shader "Unlit/NewUnlitShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {} // テクスチャの定義・使っていない
	}
	SubShader
	{
		Tags {
            		"RenderType"="Transparent"  // アルファチャンネルを使うための設定
            		"Queue"="Transparent"       // 半透明部分の描画順
		}

		Blend SrcAlpha OneMinusSrcAlpha // アルファチャンネルを使うための設定

		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert    // 頂点シェーダ
            		#pragma geometry geom  // ジオメトリシェーダ
			#pragma fragment frag  // フラグメントシェーダ

			// make fog work
			#pragma multi_compile_fog // 使っていない？
			
			#include "UnityCG.cginc" // ライブラリの宣言

			// float3を引数に取って乱数(0-1)を返す。引数が同一の場合、同じ数字が帰る（いわゆる疑似乱数）
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

				// 乱数を複数用意する
				float r5  = rand(v.vertex + 4) * 3.14159 * 2;
				float r0 = rand(v.vertex + 0) * 3.14159 * 2 + _Time.y / (1 + r5);
				float r1 = rand(v.vertex + 1) * 3.14159 * 2 + _Time.y;
				float r2 = rand(v.vertex + 2) * 3.14159 * 2 + _Time.y;
				float r3 = rand(v.vertex + 3) * 3.14159 * 2 + _Time.y;

				// ドーナツ状になるように配置する
				o.vertex.x = cos(r0) /2 * (1 + sin(r2) / 5);
				o.vertex.z = sin(r0) /2 * (1 + sin(r2) / 5);
				o.vertex.y = sin(r1)/ 5;

				//o.vertex.xz += (rand(v.vertex) - 0.5) /10 ;
				//o.vertex.z += rand(v.vertex) ;

				o.vertex.x *= 1 - pow(sin(r1)/2.5, 2);
				o.vertex.z *= 1 - pow(sin(r1)/2.5, 2);

				// 色を決める
				o.color = float4(cos(float3(-1, 1, 0) * 3.14 * 2 / 3 + r5) / 2 + 0.5, 0);

				return o;
			}
			
			
			// ジオメトリシェーダ

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
				float len = length(i.uv);
				float smooth = smoothstep(0.5, 0.1, len);

				// 三角形を円にする
				clip(0.5 - len);
				i.color.xyz = min(1, i.color.xyz + (1 - mul(len, 2.2)));
				// フチ部分をアルファチャンネルでぼかす
				return float4(i.color.xyz, smoothstep(0.5, 0.1, length(i.uv)));
			}

			ENDCG
		}
	}
}
