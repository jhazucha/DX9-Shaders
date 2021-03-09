// Globals
float4x4 WorldViewProj;
float4 LightDirection;
float Power;
texture tex;

sampler2D samp1 = sampler_state
{
	Texture	  = (tex);
  MIPFILTER = LINEAR;
  MAGFILTER = LINEAR;
  MINFILTER = LINEAR;
};

struct a2v
{
  float4 Position : POSITION0;
  float3 Normal : NORMAL0;
  float2 tex : TEXCOORD0;
};
struct v2p
{
  float4 Position : POSITION0;
  float2 tex : TEXCOORD0;
  float3 Normal : TEXCOORD1;
};
struct p2f
{
	float4 Color : COLOR0;
};

void vs(in a2v IN, out v2p OUT)
{
	// transform the position
  OUT.Position = mul(IN.Position, WorldViewProj);
  
  
  
  // pass thru the normals
  OUT.Normal = IN.Normal;
  
  // pass thru the textures
  OUT.tex = IN.tex;
}

void ps( in v2p IN, out p2f OUT )
{
 float4 c = tex2D(samp1, IN.tex);
 OUT.Color = c * Power;
}

technique Render
{
  pass p0
  {
    vertexshader = compile vs_1_1 vs();
    pixelshader = compile ps_2_0 ps();
  }
}