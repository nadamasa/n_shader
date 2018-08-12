﻿Shader "Unlit/FireworksShader"
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
            
            #include "UnityCG.cginc" // ライブラリの宣言

            // float3を引数に取って乱数(0-1)を返す。引数が同一の場合、同じ数字が帰る（いわゆる疑似乱数）
            float rand(float3 co)
            {
                return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 56.787))) * 43758.5453);
            }

            float mod(float a, float b)
            {
                return a - floor(a / b) * b;
            }

            float mod1(float a)
            {
                return a - floor(a);
            }

            float3x3 rotate(float3 a) // angle.xyz in radian
            {
                return float3x3(
                    cos(a.y) * cos(a.z),
                sin(a.x) * sin(a.y) * cos(a.z) - cos(a.x) * sin(a.z),
                cos(a.x) * sin(a.y) * cos(a.z) + sin(a.x) * sin(a.z),
                cos(a.y) * sin(a.z),
                sin(a.x) * sin(a.y) * sin(a.z) + cos(a.x) * cos(a.z),
                cos(a.x) * sin(a.y) * sin(a.z) - sin(a.x) * cos(a.z),
                -sin(a.y),
                sin(a.x) * cos(a.y),
                cos(a.x) * cos(a.y)
                );
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

                // 乱数を複数用意する
                float r5  = rand(v.vertex + 4) * 3.14159 * 2;

                float span = _Time.y / 3; // 5秒間隔で演算する
                float elapse = mod1(span) * 2; // 1スパンの経過
                float stage = floor(span);

                float r1 = rand(v.vertex + 1 + stage) * 3.14159 * 2;
                float r2 = rand(v.vertex + 2 + stage) * 3.14159 * 2;
                float r3 = rand(v.vertex + 3 + stage) * 3.14159 * 2;
                float r4 = rand(v.vertex + 3 + stage) * 3.14159 * 2 + _Time.y;

                o.vertex.xyz = float3(1, 0, 0);
                o.vertex.xyz = mul(rotate(float3(r1, r2, r3)), o.vertex.xyz);

                o.vertex.xz *= elapse;
                o.vertex.y *= elapse;

                o.vertex.y -= (2 * pow(elapse, 2)) / 2;

                // 頂点の色を決める
                // 三相コサイン波からRGBを塗る
                o.color = float4(cos(float3(-1, 1, 0) * 3.14 * 2 / 3 + span) / 2 + 0.5, 0);

                return o;
            }
            
            
            // ジオメトリシェーダ

            [maxvertexcount(3)]

            void geom(point appdata p[1], inout TriangleStream<v2f> stream){
                v2f o;

                // 頂点情報取得
                appdata v = p[0];

                // 色を引き継ぐ
                o.color = v.color;

                // ビュー座標に座標変換(塗ったポリゴンがカメラを向くように)
                float4 vp = mul(UNITY_MATRIX_MV, v.vertex);

                // 三角ポリゴンのサイズ
                float sz = 0.002 * 5;
                
                // 高さが1.5 * szの近似正三角形を描画する
                // 値は1の三乗根の解より（解が複素平面上で正三角形の関係になる）

                // 頂点1
                o.uv = float2(   0,    1); // UVを塗る
                o.vertex = mul(UNITY_MATRIX_P, vp + float4(o.uv * sz, 0, 0)); // UVに比例する頂点を設定
                stream.Append(o); // プロジェクション座標に座標変換して頂点を追加、以下同様

                // 頂点2
                o.uv = float2( 0.9, -0.5);
                o.vertex = mul(UNITY_MATRIX_P, vp + float4(o.uv * sz, 0, 0));
                stream.Append(o);

                // 頂点3
                o.uv = float2(-0.9, -0.5);
                o.vertex = mul(UNITY_MATRIX_P, vp + float4(o.uv * sz, 0, 0));
                stream.Append(o);

                // 三角ポリゴンとして出力
                stream.RestartStrip();
            }


            fixed4 frag (v2f i) : SV_Target
            {
                // ポリゴン中心点からの距離を取得
                float len = length(i.uv);
                // 発光とアルファチャンネル用の値取得
                float smooth = smoothstep(0.5, 0.1, len);

                // クリップして三角形を円にする
                clip(0.5 - len);

                // 中心部に白を塗って発光しているように見せる
                i.color.xyz = min(1, i.color.xyz + (1 - mul(len, 2.2)));

                // フチ部分をアルファチャンネルでぼかす
                return float4(i.color.xyz, smoothstep(0.5, 0.1, length(i.uv)));
            }

            ENDCG
        }
    }
}
