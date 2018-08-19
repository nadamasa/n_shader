Shader "Unlit/FireworksShader"
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
                o.uv = v.uv;
                float2 uv;

                // 乱数を複数用意する

                float span = _Time.y / 3.14; // 5秒間隔で演算する
                float elapse = mod1(span) * 1.5; // 1スパンの経過
                float stage = floor(span);

                float rand0 = rand(stage) * 3.14159 * 2;
                float rand1 = rand(v.vertex + 1 + stage) * 3.14159 * 2;
                float rand2 = rand(v.vertex + 2 + stage) * 3.14159 * 2;
                float rand3 = rand(v.vertex + 3 + stage) * 3.14159 * 2;
                float rand4 = rand(4 + stage);
                float rand5 = rand(5 + stage);
                float rand6 = rand(6 + stage);
                float rand7 = rand(stage + 1) * 3.14159 * 2;
                float rand8 = rand(v.vertex + 8 + stage);
                float rand9 = rand(v.vertex + 8 + stage);



                //if(v.vertex.x > 0.1 && v.vertex.x < 0.2){
                if(rand8 > 0.1 && rand8 < 0.2){
                    // 初期ベクトル
                    o.vertex.xyz = float3((1 + rand1 / 50) ,0 ,0 );
                    // 頂点の色を決める
                    // 三相コサイン波からRGBを塗る
                    o.color = float4(cos(float3(-1, 1, 0) * 3.14 * 2 / 3 + rand0 + rand9 / 2) / 2 + 0.5, 0);
                
                }else if(rand8 > 0.2 && rand8 < 0.3){
                    // 初期ベクトル
                    o.vertex.xyz = float3(0.5 + rand1 / 50, rand4 / 20, rand5 / 20);
                    o.color = float4(cos(float3(-1, 1, 0) * 3.14 * 2 / 3 + rand0 + 3.14 + rand9 / 2) / 2 + 0.5, 0);
                }else if(rand8 > 0.3 && rand8 < 0.4){
                    span = _Time.y / 2.53; // 5秒間隔で演算する
                    elapse = mod1(span) * 1.5; // 1スパンの経過
                    stage = floor(span);

                    rand0 = rand(stage) * 3.14159 * 2;
                    rand1 = rand(v.vertex + 1 + stage) * 3.14159 * 2;
                    rand2 = rand(v.vertex + 2 + stage) * 3.14159 * 2;
                    rand3 = rand(v.vertex + 3 + stage) * 3.14159 * 2;
                    rand4 = rand(4 + stage);
                    rand5 = rand(5 + stage);
                    rand6 = rand(6 + stage);
                    rand7 = rand(stage + 1) * 3.14159 * 2;
                    rand8 = rand(v.vertex + 8 + stage);
                    rand9 = rand(v.vertex + 8 + stage);
                    o.vertex.xyz = float3(0.5 + rand1 / 50, rand4 / 20, rand5 / 20);
                    o.color = float4(cos(float3(-1, 1, 0) * 3.14 * 2 / 3 + rand0 + 3.14 + rand9 / 2) / 2 + 0.5, 0);
                }else if(rand8 > 0.4 && rand8 < 0.5){
                    span = _Time.y / 4.1; // 5秒間隔で演算する
                    elapse = mod1(span) * 1.5; // 1スパンの経過
                    stage = floor(span);

                    rand0 = rand(stage) * 3.14159 * 2;
                    rand1 = rand(v.vertex + 1 + stage) * 3.14159 * 2;
                    rand2 = rand(v.vertex + 2 + stage) * 3.14159 * 2;
                    rand3 = rand(v.vertex + 3 + stage) * 3.14159 * 2;
                    rand4 = rand(4 + stage);
                    rand5 = rand(5 + stage);
                    rand6 = rand(6 + stage);
                    rand7 = rand(stage + 1) * 3.14159 * 2;
                    rand8 = rand(v.vertex + 8 + stage);
                    rand9 = rand(v.vertex + 8 + stage);
                    o.vertex.xyz = float3(0.5 + rand1 / 50, rand4 / 20, rand5 / 20);
                    o.color = float4(cos(float3(-1, 1, 0) * 3.14 * 2 / 3 + rand0 + 3.14 + rand9 / 2) / 2 + 0.5, 0);
                }else if(rand8 > 0.5 && rand8 < 0.6){
                    span = _Time.y / 5.13; // 5秒間隔で演算する
                    elapse = mod1(span) * 1.5; // 1スパンの経過
                    stage = floor(span);

                    rand0 = rand(stage) * 3.14159 * 2;
                    rand1 = rand(v.vertex + 1 + stage) * 3.14159 * 2;
                    rand2 = rand(v.vertex + 2 + stage) * 3.14159 * 2;
                    rand3 = rand(v.vertex + 3 + stage) * 3.14159 * 2;
                    rand4 = rand(4 + stage);
                    rand5 = rand(5 + stage);
                    rand6 = rand(6 + stage);
                    rand7 = rand(stage + 1) * 3.14159 * 2;
                    rand8 = rand(v.vertex + 8 + stage);
                    rand9 = rand(v.vertex + 8 + stage);
                    o.vertex.xyz = float3(0.3 + rand1 / 50, rand4 / 20, rand5 / 20);
                    o.color = float4(cos(float3(-1, 1, 0) * 3.14 * 2 / 3 + rand0 + 3.14 + rand9 / 2) / 2 + 0.5, 0);
                }else{
                    o.vertex.xyz = float3(-10000,-10000,0);
                    o.color = (0,0,0,0);
                }


                // ランダムに回転させる
                o.vertex.xyz = mul(rotate(float3(rand1, rand2, rand3)), o.vertex.xyz);

                // ベクトルに沿って移動させるが、経過時間が長いと減速する
                o.vertex.xyz *= elapse * pow(0.98, elapse * 10);

                // o.vertex.y += 2; // 高めに表示
                o.vertex.y -= (0.7 * pow(elapse, 2)) / 2; // 重力に従って落ちる

                // 位置をずらす
                o.vertex.xyz += float3(rand4, rand5, rand6);




                return o;
            }
            
            
            struct gsps_input {
                // float2 Tex : TEXCOORD1;
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            // ジオメトリシェーダ

            [maxvertexcount(3)]

            void geom(point gsps_input p[1], inout TriangleStream<gsps_input> stream){
                gsps_input o;

                // 頂点情報取得
                gsps_input v = p[0];

                // 色を引き継ぐ
                o.color = v.color;

                // ビュー座標に座標変換(塗ったポリゴンがカメラを向くように)
                float4 vp = mul(UNITY_MATRIX_MV, v.vertex);

                // 三角ポリゴンのサイズ
                float sz = 0.002 * 10;
                
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
