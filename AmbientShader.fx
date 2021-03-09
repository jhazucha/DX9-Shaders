float4x4 World : WORLD;
float4x4 View;
float4x4 Projection;

texture Texture;

struct VertexShaderInput
{
  float4 Position : POSITION0;
	float3 Normal : NORMAL0;
	float2 TexCoord : TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 Position : POSITION0;
	float2 TexCoord : TEXCOORD0;
	float3 Normal : TEXCOORD1;
};

sampler2D samp1 : TEXUNIT0 = sampler_state
{
	Texture	  = (Texture);
  MipFilter = LINEAR;
  MagFilter = LINEAR;
  MinFilter = LINEAR;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	VertexShaderOutput output;
	
	float4x4 WorldViewProjection = mul(mul(World, View), Projection);
  output.Position = mul(input.Position, WorldViewProjection);
	output.TexCoord = input.TexCoord;
	
	float3 nml= mul(input.Normal, WorldViewProjection);
	nml = normalize(nml);
	
	output.Normal = nml;
	
  return output;
}

float4 PSAmbient(VertexShaderOutput input) : COLOR0
{
	return tex2D(samp1, input.TexCoord);
}

technique Ambient
{
  pass Pass1
  {
    VertexShader = compile vs_2_0 VertexShaderFunction();
		PixelShader = compile ps_2_0 PSAmbient();
  }
}