float4x4 ModelViewProj	: WORLDVIEWPROJECTION;  // World view projection matrix
float4x4 ModelViewIT	: WORLDVIEWIT;			// Inverse transpose matrix
float4x4 ModelWorld		: WORLD;				// World matrix

float4 lightPosition;							// Light position
float lightAmbient;								// Light intensity
float4 eyePos;									// Eye Position

texture texture0;								// Texture
texture texture1;								// Normal Mapped Texture

sampler2D texSampler0 : TEXUNIT0 = sampler_state
{
  texture	  = (texture0);
  MipFilter = LINEAR;
  MagFilter = LINEAR;
  MinFilter = LINEAR;
};

sampler2D texSampler1 : TEXUNIT1 = sampler_state
{
  texture   = (texture1);
  MipFilter = LINEAR;
  MagFilter = LINEAR;
  MinFilter = LINEAR;
};
 
//application to vertex struct
struct a2v
{ 
  float4 position		: POSITION0;
  float3 normal			: NORMAL;
  float2 tex0       : TEXCOORD0;
  float3 tangent    : TANGENT;
  float3 binormal	  : BINORMAL;
};
 
//vertex to pixel shader struct
struct v2p
{
  float4 position	    : POSITION0;
  float2 tex0         : TEXCOORD0;
  float2 tex1         : TEXCOORD1;
  float3 lightVec     : TEXCOORD2;
  float  att					: TEXCOORD3;
  float3 vHalf				: TEXCOORD4;
};
 
//pixel shader to screen
struct p2f
{
  float4 color    : COLOR0;
};

// Vertex Shader
void vs( in a2v IN, out v2p OUT ) 
{
    //getting to position to object space
    OUT.position    = mul(IN.position, ModelViewProj);
 
    //getting the position of the vertex in the world
    float4 posWorld = mul(IN.position, ModelWorld);
 
    //getting vertex -> light vector
    float3 light = normalize(lightPosition - posWorld);
    
    //getting the eye -> eye Vector
    float3 eye = normalize(eyePos - light);
    
    //placing the half vector in the object space
    float3 vHalf = normalize(eye - lightPosition);
	
    //calculating the binormal and setting the Tangent Binormal and Normal matrix
    float3x3 TBNMatrix = float3x3(IN.tangent, IN.binormal , IN.normal); 
 
    //setting the lightVector
    OUT.lightVec = mul(TBNMatrix, light);
    
    //setting the half vector and passing it to the pixel shader
    OUT.vHalf = mul(TBNMatrix, vHalf);
    
    //calculate the attenuation
    OUT.att = 1/( 1 + ( 0.005f * distance(lightPosition.xyz, posWorld) ) );
 
		// send our textures out
    OUT.tex0 = IN.tex0;
    OUT.tex1 = IN.tex0;
}
 
// Pixel Shader
void ps( in v2p IN, out p2f OUT )
{
  //calculate the color and the normal
  float4 color = tex2D(texSampler0, IN.tex0);
 
  // uncompress the normal map
  float3 normal = 2.0f * tex2D(texSampler1, IN.tex1).rgb - 1.0f;
 
  //normalize our light
  float3 light = normalize(IN.lightVec);
   
  //normalize half vector
  float3 vHalf = normalize(IN.vHalf);
    
  //set the output color
  float diffuse = saturate(dot(normal, light));
    
  //calculating the specular component
  float specular = pow(dot( normal, IN.vHalf) , 20);
    
  //setting ds(diffuse * specular)Color
  float dsColor = 2.0 * (diffuse * specular) + lightAmbient;
    
  //multiply attenuation with the color
	OUT.color = IN.att * color * dsColor;
}
 
technique bump
{
  pass p0
  {
		VertexShader = compile vs_1_1 vs();
    PixelShader = compile ps_2_0 ps();
  }
}