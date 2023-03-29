Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        //_Tex1("Texture1", 2D) = "white" {}
        //_Tex2("Texture2", 2D) = "white" {}
        //_MixValue("Mix Value", Range(0,1)) = 0.5
        _Color("Main Color", COLOR) = (1,1,1,1)


        _MainTex ("Texture", 2D) = "White" {}
        _Height("Height", Range(-20,20)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100


        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float _Height;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;

                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;

              //  v.vertex.xyz -= v.normal * _Height * v.uv.x * v.uv.x * v.uv.x;
                v.vertex.y += sin(v.uv.x * _Height)*2;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
