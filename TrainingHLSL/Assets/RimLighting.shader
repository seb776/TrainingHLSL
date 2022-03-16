Shader "Unlit/RimLighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SurfaceColor("Surface Color", Color) = (1,1,1,1)
        _LightColor("LightCol", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        //UsePass "Universal Render Pipeline/Lit/ForwardLit"
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            //void Main()
            //{
            //    (tableau qui contiuent les vertex)

            //        while (sur tous les vertex)
            //        {
            //            appdata data;
            //            data.vertex = vertex;
            //            data.uv = uv;
            //            data.normal = normal;
            //            v2f result = vert(data);
            //            for (pixel in triangle)
            //            {

            //                fragment(result);
            //            }
            //        }
            //}

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                float3 viewDir : TEXCOORD5;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float3 _SurfaceColor;
            float3 _LightColor;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);//v.normal;//mul(unity_ObjectToWorld, v.normal);
                o.viewDir = ObjSpaceViewDir(v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                
                float3 lightPos = float3(0., 5., 0.);

                float depth = distance(_WorldSpaceCameraPos, i.worldPos);

                float L = float3(1, 1, 1);//normalize(i.worldPos - lightPos);
                
                col.w = 1.;

                col.xyz = _LightColor*_SurfaceColor *saturate(-dot(L, i.normal));

                float3 H = normalize(-L + -i.viewDir);
                float spec = tex2D(_MainTex, i.uv * 1.).x+tex2D(_MainTex, i.vertex.xy * 10.);

                col.xyz += float3(1, 1, 1) * pow(saturate(dot(H, i.normal)), spec)/5.;
            
                //col.xyz = i.normal;// *.5 + .5;
                //col.xyz = _LightColor * _SurfaceColor * (1.-saturate(dot(i.viewDir, i.normal)));
                //col.w = length(col.xyz);
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
